import 'package:final_year_project/screens/game/gamehome.dart';
import 'package:final_year_project/screens/game/matchmakingscreen.dart';
import 'package:final_year_project/screens/game/questions.dart';
import 'package:final_year_project/screens/home_statistics/widgets/home_background.dart';
import 'package:final_year_project/screens/home_statistics/widgets/home_info.dart';
import 'package:flutter/material.dart';

import 'widgets/home_gameInfo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return HomeBackground(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                children: const [
                  HomeInfo(
                    child: Text.rich(
                      TextSpan(
                        style: TextStyle(fontSize: 17),
                        children: [
                          WidgetSpan(
                            child: ImageIcon(
                              AssetImage('assets/images/heart.png'),
                            ),
                          ),
                          TextSpan(
                            text: '4',
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  HomeInfo(
                    child: Text.rich(
                      TextSpan(
                        style: TextStyle(fontSize: 17),
                        children: [
                          WidgetSpan(
                            child: Icon(Icons.money),
                          ),
                          TextSpan(
                            text: '4000',
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => const Matchmaking()));
              },
              style: ElevatedButton.styleFrom(
                // ignore: todo
                //TODO: Oyna butonu büyütülecek ve rengi değiştirilecek
                minimumSize: const Size(56, 56),
                shape: const CircleBorder(),
              ),
              child: const Text('OYNA'),
            ),
            const SizedBox(
              height: 100,
            ),
            const HomeGameInfo(),
          ],
        ),
      ),
    );
  }
}
