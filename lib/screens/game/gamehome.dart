import 'dart:async';
import 'dart:math';
import 'package:final_year_project/screens/game/questions.dart';
import 'package:final_year_project/screens/game/widget/nickCategoriesCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:final_year_project/screens/game/theme/color.dart';
import 'package:final_year_project/screens/game/widget/mytext.dart';
import 'package:final_year_project/screens/game/widget/myappbar.dart';

//TODO:Geri butonuna basıldığında oyundan çıkmak istiyormusunuz diye sor ve eğer kabul ederse yenildi diye kabul et.

class GameHome extends StatefulWidget {
  const GameHome({Key? key}) : super(key: key);

  @override
  _GameHomeState createState() => _GameHomeState();
}

class _GameHomeState extends State<GameHome> {
  final StreamController<int> controller = StreamController<int>();
  late Random random;

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    random = Random();
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
        title: "Tur 1/12",
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
              topLeft: Radius.circular(40), topRight: Radius.circular(40)),
          child: Container(
            color: white,
            alignment: Alignment.center,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Card(
                    child: NickAndCategoriesCard(
                      categories: ["EN-TR", "TR-EN", "SYN", "ANT"],
                      player1Name: 'berkili',
                      player2Name: 'berkili1',
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FortuneWheel(
                        selected: controller.stream,
                        items: const [
                          FortuneItem(
                            child: Text(
                              'EN-TR',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            style: FortuneItemStyle(
                              color: wheelOne,
                              borderColor: black,
                              borderWidth: 5,
                            ),
                          ),
                          FortuneItem(
                            child: Text(
                              'TR-EN',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            style: FortuneItemStyle(
                              color: wheelTwo,
                              borderColor: black,
                              borderWidth: 5,
                            ),
                          ),
                          FortuneItem(
                            child: Text(
                              'SYN',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            style: FortuneItemStyle(
                              color: wheelThree,
                              borderColor: black,
                              borderWidth: 5,
                            ),
                          ),
                          FortuneItem(
                            child: Text(
                              'ANT',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            style: FortuneItemStyle(
                              color: wheelFour,
                              borderColor: black,
                              borderWidth: 5,
                            ),
                          ),
                        ],
                      )),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.06,
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: TextButton(
                      onPressed: () {
                        controller.add(random.nextInt(4));
                        //BUG: Dönmeden diğer sayfaya geçiyor.
                        //TODO: Bu kısımda questions sayfasına kategori parametre olarak gönderilecek.
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Questions()),
                        );
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(primary),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      side: const BorderSide(color: primary)))),
                      child: MyText(
                        title: "Döndür",
                        colors: white,
                        fontWeight: FontWeight.w500,
                        size: 18,
                      )),
                )
              ],
            ),
          )),
    );
  }
}
