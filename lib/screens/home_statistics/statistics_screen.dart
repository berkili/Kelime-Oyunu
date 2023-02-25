import 'package:final_year_project/screens/home_statistics/widgets/home_background.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math';

import 'models/leader_board_items.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  List<LeaderBoardItem> _leaderBoardItems = <LeaderBoardItem>[];
  Random random = Random();

  @override
  Widget build(BuildContext context) {
    generateDummyData();
    return HomeBackground(
      child: ListView.builder(
        itemCount: _leaderBoardItems.length,
        itemBuilder: (BuildContext ctxt, int index) => buildList(ctxt, index),
      ),
    );
  }

  Widget buildList(BuildContext ctxt, int index) {
    //TODO: Bitiş süresi eklenecek onun dışında her şey hazır.
    int ind = index + 1;

    Widget crown;

    if (ind == 1) {
      crown = Padding(
          padding: const EdgeInsets.only(right: 0.0),
          child: Stack(
            alignment: Alignment.center,
            children: const <Widget>[
              Center(
                  child: Icon(
                FontAwesomeIcons.crown,
                size: 42,
                color: Colors.yellow,
              )),
              Padding(
                padding: EdgeInsets.only(left: 8.0, top: 12),
                child: Center(
                    child: Text(
                  '1',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                )),
              )
            ],
          ));
    } else if (ind == 2) {
      crown = Padding(
          padding: const EdgeInsets.only(right: 0.0),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Center(
                  child: Icon(
                FontAwesomeIcons.crown,
                size: 42,
                color: Colors.grey[300],
              )),
              const Padding(
                padding: EdgeInsets.only(left: 8.0, top: 12),
                child: Center(
                    child: Text(
                  '2',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                )),
              )
            ],
          ));
    } else if (ind == 3) {
      crown = Padding(
          padding: const EdgeInsets.only(right: 0.0),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Center(
                  child: Icon(
                FontAwesomeIcons.crown,
                size: 42,
                color: Colors.orange[300],
              )),
              const Padding(
                padding: EdgeInsets.only(left: 8.0, top: 12),
                child: Center(
                    child: Text(
                  '3',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                )),
              )
            ],
          ));
    } else {
      crown = CircleAvatar(
          backgroundColor: Colors.grey,
          radius: 13,
          child: Text(
            ind.toString(),
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
          ));
    }

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 10),
      child: Container(
        height: 100,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5.0)]),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(right: 0.0),
                  child: Row(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0, right: 25),
                          child: crown,
                        ),
                      ),
                      Align(
                        child: CircleAvatar(
                          backgroundColor: Color.fromRGBO(
                            random.nextInt(255),
                            random.nextInt(255),
                            random.nextInt(255),
                            1,
                          ),
                          radius: 30,
                          child: const Text(
                            'US',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Align(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 5),
                            child: Text(
                              _leaderBoardItems[index].name,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ),
                        ],
                      )),
                    ],
                  ),
                ),
              ),
            ),
            const Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.all(18.0),
                child: Text(
                  "0",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void generateDummyData() {
    _leaderBoardItems = <LeaderBoardItem>[];

    for (var i = 1; i < 21; i++) {
      LeaderBoardItem lbi = LeaderBoardItem(
        userId: 'user$i',
        name: 'User $i',
        email: 'user$i@gmail.com',
        point: (1000 + i).toString(),
      );

      _leaderBoardItems.add(lbi);
    }

    _leaderBoardItems = _leaderBoardItems.reversed.toList();
  }
}
