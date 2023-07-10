import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_timer/custom_timer.dart';
import 'package:final_year_project/screens/game/questions.dart';
import 'package:final_year_project/screens/game/widget/nickCategoriesCard.dart';
import 'package:final_year_project/screens/socket/socketManager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:final_year_project/screens/game/theme/color.dart';
import 'package:final_year_project/screens/game/widget/mytext.dart';
import 'package:final_year_project/screens/game/widget/myappbar.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:socket_io_common/src/util/event_emitter.dart';

//TODO:Geri butonuna basıldığında oyundan çıkmak istiyormusunuz diye sor ve eğer kabul ederse yenildi diye kabul et.

class GameHome extends StatefulWidget {
  dynamic data;

  GameHome(this.data, {Key? key}) : super(key: key);

  @override
  _GameHomeState createState() => _GameHomeState();
}

// Define an enum for game states
enum _GameState {
  INITIAL_TIMEOUT,
  WAITING_ANSWERS_OR_TIMEOUT,
  ROUND_END_TIMEOUT,
  GAME_END
}

// Define a struct for player infos
class _PlayerInfo {
  String userId;
  String userName;
  _PlayerInfo(this.userId, this.userName);
}

class _GameHomeState extends State<GameHome> {
  final StreamController<int> controller = StreamController<int>();
  final CustomTimerController _controller = CustomTimerController();

  _GameState _gameState = _GameState.INITIAL_TIMEOUT;

  int round_countdown = 0;
  int timeout = 0;
  int round = 0;
  int answerTimeout = 0;
  dynamic questionData;

  int sonuc = 5;

  _PlayerInfo? _opponent;

  Timer? roundTimer;
  int initialCountdown = 0;

  String? playerFirstName = " ";
  String? playerSecondName = " ";

  //Questions
  double percent = 0.0;
  Timer? timer;

  int answercnt = 1;
  int selectAnswer = -1;

  int correctAnswersCount = 0;

  bool isCorrect = false;

  List question = [];
  List answer = [];
  List rightAnswer = [];
  List<int> correctAnswerIndices = [];

  @override
  void initState() {
    super.initState();
    addSocketEventListeners();

    _opponent = _PlayerInfo(
        widget.data["opponent"]["userId"], widget.data["opponent"]["userName"]);

    startTimer(widget.data["INITIAL_TIMEOUT"] ~/ 1000);
    setPlayerName();
  }

  @override
  void dispose() {
    controller.close();
    removeSocketEventListeners();
    roundTimer?.cancel();
    super.dispose();
  }

  void onRoundStart(data) {
    setState(() {
      _gameState = _GameState.WAITING_ANSWERS_OR_TIMEOUT;
      round = data["round"];
      questionData = data["question"];
      answerTimeout = data["ANSWER_TIMEOUT"] ~/ 1000;
      selectAnswer = -1;
    });

    startTimer(data["ANSWER_TIMEOUT"] ~/ 1000);
  }

  void startTimer(secs) {
    roundTimer?.cancel();
    round_countdown = secs;
    roundTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        round_countdown--;
        if (round_countdown == 0) {
          roundTimer?.cancel();
        }
      });
    });
  }

  void onRoundEnd(data) {
    setState(() {
      _gameState = _GameState.ROUND_END_TIMEOUT;
      timeout = data["TIMEOUT"];
    });

    startTimer(data["TIMEOUT"] ~/ 1000);
  }

  void onGameEnd(data) {
    setState(() {
      _gameState = _GameState.GAME_END;
      sonuc = data["sonuc"];
    });
  }

  void addSocketEventListeners() {
    SocketManager.socket?.on("roundStart", onRoundStart);
    SocketManager.socket?.on("roundEnd", onRoundEnd);
    SocketManager.socket?.on("gameEnd", onGameEnd);
  }

  void removeSocketEventListeners() {
    SocketManager.socket?.off("roundStart", onRoundStart);
    SocketManager.socket?.off("roundEnd", onRoundEnd);
    SocketManager.socket?.off("gameEnd", onGameEnd);
  }

  void setPlayerName() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    final userName = user?.email?.substring(0, user.email?.indexOf("@"));
    playerFirstName = "@$userName";
    playerSecondName = "${_opponent?.userName}";
  }

  void onClickOption(index) {
    SocketManager.socket?.emit("answer", {"index": index});
  }

  // void onQuestions(data) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => Questions(data)),
  //   );
  // }

  // Eğer _gameState = INITAL_TIMEOUT durumundaysak
  // INITIAL_TIMEOUT değerinden geriye doğru sayan bir sayaç göster

  // Eğer WAITING_ANSWERS_OR_TIMEOUT durumundaysak kullanıcının round, questionData ve answerTimeout değerlerini kullanarak soru ekranını göster

  // Eğer ROUND_END_TIMEOUT durumundaysak kullanıcıya round sonu bekleme sayacını göster

  // Eğer GAME_END durumundaysak kullanıcıya oyun sonu ekranını göster

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/login_bg.png"),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        appBar: getAppbar(),
        backgroundColor: Colors.transparent,
        body: manageHandle(),
      ),
    );
  }

  manageHandle() {
    if (_gameState == _GameState.INITIAL_TIMEOUT) {
      return spinwheel();
    } else if (_gameState == _GameState.WAITING_ANSWERS_OR_TIMEOUT) {
      return questions();
    } else if (_gameState == _GameState.ROUND_END_TIMEOUT) {
      return counterAnswer();
    } else if (_gameState == _GameState.GAME_END) {
      return levelresult();
    } else {
      return Container();
    }
  }

  getAppbar() {
    return const PreferredSize(
      preferredSize: Size.fromHeight(60.0),
      child: MyAppbar(
        title: "Game",
      ),
    );
  }

  spinwheel() {
    setPlayerName();
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        child: Container(
          color: white,
          alignment: Alignment.center,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Card(
                  child: NickAndCategoriesCard(
                    player1Name: playerFirstName!,
                    player2Name: playerSecondName!,
                    categories: const ["EN-TR", "TR-EN", "SYN", "ANT"],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 100),
                        const Text(
                          "Sorular hazırlandı",
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Kalan Süre: $round_countdown saniye",
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget questions() {
    _controller.start();
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/appbg.png"),
          fit: BoxFit.fill,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/login_bg_white.png"),
                  fit: BoxFit.fill,
                ),
              ),
              child: Container(
                margin: const EdgeInsets.only(left: 30, right: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.transparent,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Positioned(
                            child: Container(
                              height: 70,
                              width: 70,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: primary, width: 4),
                                color: white,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(100)),
                              ),
                              child: CircularPercentIndicator(
                                radius: 30.0,
                                lineWidth: 4.0,
                                animation: false,
                                percent: percent / 100,
                                center: Text(
                                  round_countdown.toString(),
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                backgroundColor: Colors.grey,
                                circularStrokeCap: CircularStrokeCap.round,
                                progressColor: Colors.redAccent,
                              ),
                            ),
                          ), // Question Count
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    MyText(
                      title: questionData["question"].toString(),
                      fontWeight: FontWeight.w500,
                      size: 18,
                      maxline: 4,
                      textalign: TextAlign.center,
                      colors: textColorGrey,
                    ),
                    const SizedBox(height: 25),
                    Container(
                      alignment: Alignment.topCenter,
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      height: MediaQuery.of(context).size.height * 0.35,
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: answercnt,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: answercnt == 1
                              ? MediaQuery.of(context).size.width /
                                  (MediaQuery.of(context).size.height / 12)
                              : MediaQuery.of(context).size.width /
                                  (MediaQuery.of(context).size.height / 7),
                        ),
                        itemCount: 4,
                        itemBuilder: (BuildContext ctx, index) {
                          List<dynamic> choices = questionData["options"];

                          return InkWell(
                            onTap: () {
                              if (selectAnswer != -1) return;
                              setState(() {
                                selectAnswer = index;
                              });
                              onClickOption(index);
                            },
                            child: Container(
                              alignment: Alignment.centerLeft,
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              padding:
                                  const EdgeInsets.only(left: 25, right: 10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: selectAnswer == index
                                      ? Colors.green
                                      : textColorGrey,
                                  width: 0.4,
                                ),
                                color: selectAnswer == index
                                    ? isCorrect
                                        ? Colors.green
                                        : Colors.red
                                    : Colors.transparent,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(25)),
                              ),
                              child: MyText(
                                title: choices[index].toString(),
                                overflow: TextOverflow.ellipsis,
                                maxline: 2,
                                size: 18,
                                colors: selectAnswer == index
                                    ? Colors.white
                                    : textColorGrey,
                                fontWeight: FontWeight.w500,
                                textalign: TextAlign.left,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget counterAnswer() {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/login_bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Yeni soru hazırlanıyor...",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  "$round_countdown saniye sonra yeni round başlayacak.",
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  levelresult() {
    // Show "sonuc" int variable

    String sonucYazisi = sonuc == -1
        ? "Berabere"
        : sonuc == 0
            ? "Kaybettin"
            : sonuc == 1
                ? "Kazandın"
                : "Hata";

    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$sonucYazisi",
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
