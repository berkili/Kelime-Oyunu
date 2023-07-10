import 'dart:async';

import 'package:custom_timer/custom_timer.dart';
import 'package:final_year_project/screens/socket/socketManager.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:final_year_project/screens/game/levelresult.dart';
import 'package:final_year_project/screens/game/theme/color.dart';
import 'package:final_year_project/screens/game/widget/mytext.dart';

class Questions extends StatefulWidget {
  Questions(this.data, {Key? key}) : super(key: key);

  final dynamic data;

  @override
  _QuestionsState createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {
  final CustomTimerController _controller = CustomTimerController();

  double percent = 0.0;
  Timer? timer;

  int quecnt = 0;
  int answercnt = 1;
  int selectAnswer = -1;

  int correctAnswersCount = 0;

  bool isCorrect = false;

  List question = [];
  List answer = [];
  List rightAnswer = [];
  List category = ["English-Turkish", "Turkish-English", "Synonym", "Antonym"];

  List<int> correctAnswerIndices = []; // Yeni eklenen liste

  void setQuestions() {
    List<dynamic> questions = widget.data;

    question.clear();
    answer.clear();
    rightAnswer.clear();

    for (int i = 0; i < questions.length; i++) {
      Map<String, dynamic> item = questions[i];

      question.add(item['soru']);
      rightAnswer.add(item['dogru_cevap']);

      String choices =
          "A. ${item['a']},B. ${item['b']},C. ${item['c']},D. ${item['d']}";
      answer.add(choices);
    }
  }

  @override
  void initState() {
    super.initState();
    counter();
    setQuestions();
  }

  @override
  void dispose() {
    _controller.dispose();
    timer?.cancel();
    super.dispose();
  }

  void counter() {
    timer = Timer.periodic(Duration(milliseconds: 1000), (_) {
      setState(() {
        percent += 1;
        if (percent >= 100) {
          timer?.cancel();
          percent = 0;
          print(percent);
          _checkAnswer();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _controller.start();
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/appbg.png"),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: AppBar(
            title: MyText(
              title: category[quecnt],
              size: 18,
              fontWeight: FontWeight.w400,
              colors: white,
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: Colors.transparent,
          ),
        ),
        body: SafeArea(
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
                                    percent.toInt().toString(),
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
                        title: question[quecnt].toString(),
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
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
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
                            List<String> choices = answer[quecnt].split(',');

                            return InkWell(
                              onTap: () {
                                setState(() {
                                  selectAnswer = index;
                                  timer?.cancel();
                                  percent = 0;
                                  _checkAnswer();
                                });
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(25)),
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
      ),
    );
  }

  void _checkAnswer() {
    int selectedAnswerIndex = selectAnswer;
    String correctAnswer = rightAnswer[quecnt].trim().toLowerCase();

    List<String> answerList = answer[quecnt].split(',');
    String selectedAnswer = '';
    if (selectedAnswerIndex >= 0 && selectedAnswerIndex < answerList.length) {
      selectedAnswer =
          answerList[selectedAnswerIndex].split('.').first.toLowerCase();
    }

    isCorrect = selectedAnswer == correctAnswer;

    if (!isCorrect) {
      String correctChoice = correctAnswer;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Doğru şık: $correctChoice"),
      ));
    } else {
      correctAnswerIndices
          .add(quecnt); // Doğru bilinen sorunun index numarasını kaydet
    }

    Timer(Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        if (quecnt < question.length - 1) {
          quecnt += 1;
          answercnt = 1;
          timer?.cancel();
          percent = 0;
          selectAnswer = -1;
          counter();
        } else {
          setCorrectCategory();
        }
      });
    });
  }

  void setCorrectCategory() {
    SocketManager.socket?.emit('correctAnswers', correctAnswerIndices);
    SocketManager.socket?.on("result", onResult);
  }

  void onResult(data) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => LevelResult(data),
    ));
  }
}
