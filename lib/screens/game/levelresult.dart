import 'dart:async';
import 'dart:math';
import 'package:final_year_project/screens/game/questions.dart';
import 'package:final_year_project/screens/game/widget/nickCategoriesCard.dart';
import 'package:final_year_project/screens/socket/socketManager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:final_year_project/screens/game/theme/color.dart';
import 'package:final_year_project/screens/game/widget/mytext.dart';
import 'package:final_year_project/screens/game/widget/myappbar.dart';
import 'package:socket_io_common/src/util/event_emitter.dart';

//TODO:Geri butonuna basıldığında oyundan çıkmak istiyormusunuz diye sor ve eğer kabul ederse yenildi diye kabul et.

class LevelResult extends StatefulWidget {
  dynamic data;

  LevelResult(this.data, {Key? key}) : super(key: key);

  @override
  _LevelResultState createState() => _LevelResultState();
}

class _LevelResultState extends State<LevelResult> {
  final StreamController<int> controller = StreamController<int>();
  String? playerFirstName = " ";
  String? playerSecondName = " ";

  Timer? timer;
  int countdown = 15;

  @override
  void dispose() {
    controller.close();
    timer?.cancel(); // Cancel the timer if it's active
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setPlayerName();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        countdown--;
      });
    });
  }

  void setPlayerName() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    final userName = user?.email?.substring(0, user.email?.indexOf("@"));
    playerFirstName = "@$userName";
    playerSecondName = widget.data["userName"];
  }

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
        body: spinwheel(),
      ),
    );
  }

  getAppbar() {
    return const PreferredSize(
      preferredSize: Size.fromHeight(60.0),
      child: MyAppbar(
        title: "Result",
      ),
    );
  }

  spinwheel() {
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
                    player1Name: playerFirstName,
                    player2Name: playerSecondName,
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
                          "Geçen Süre: $countdown saniye",
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
}
