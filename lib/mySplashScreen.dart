import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project/screens/home_statistics/tabs_screen.dart';
import 'package:final_year_project/screens/socket/socketManager.dart';
import 'package:final_year_project/screens/welcome/utils/googleSignIn.dart';
import 'package:final_year_project/screens/welcome/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    Future.delayed(const Duration(seconds: 5), () async {
      try {
        final user = _auth.currentUser;
        final emailPrefix = user!.email?.substring(0, user.email?.indexOf("@"));
        if (user != null) {
          FirebaseFirestore firestore = FirebaseFirestore.instance;
          final loginDocument = await firestore.collection("login").add(
            {
              "userId": user.uid,
              "used": false,
              "userName": "@$emailPrefix",
            },
          );
          await SocketManager.connect(loginDocument.id);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const TabsScreen()),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const WelcomeScreen()),
          );
        }
        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        print(e);
        SocketManager.disconnect();
        await FirebaseAuth.instance.signOut(); // Sign out from Firebase Auth
        await googleSignIn.signOut();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RotationTransition(
              turns: Tween(begin: 0.0, end: 1.0).animate(_animationController),
              child: const Text(
                'Spinning Quiz',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
