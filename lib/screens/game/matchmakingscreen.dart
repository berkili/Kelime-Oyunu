import 'dart:async';
import 'dart:io';

import 'package:final_year_project/screens/game/gamehome.dart';
import 'package:final_year_project/screens/home_statistics/tabs_screen.dart';
import 'package:final_year_project/screens/socket/socketManager.dart';
import 'package:flutter/material.dart';

class Matchmaking extends StatefulWidget {
  const Matchmaking({Key? key}) : super(key: key);

  @override
  State<Matchmaking> createState() => _MatchmakingState();
}

class _MatchmakingState extends State<Matchmaking> {
  Timer? timer;
  int countdown = 0;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        countdown++;
      });
    });

    joinQueue();
  }

  void joinQueue() {
    SocketManager.socket?.emit("queue");
    SocketManager.socket?.once("match", onMatch);
  }

  void onMatch(data) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const GameHome()),
    );
  }

  @override
  void dispose() {
    super.dispose();

    SocketManager.socket?.emit("dequeue");
    SocketManager.socket?.off("match", onMatch);
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
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
                  "Rakip Aranıyor",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  "Geçen Süre: $countdown saniye",
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 100,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const TabsScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.all(0),
                    ),
                    child: const Text("Geri Dön"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
