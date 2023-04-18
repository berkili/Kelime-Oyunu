import 'package:final_year_project/firebase_options.dart';
import 'package:final_year_project/mySplashScreen.dart';
import 'package:final_year_project/screens/home_statistics/home_screen.dart';
import 'package:final_year_project/screens/home_statistics/tabs_screen.dart';
import 'package:final_year_project/screens/login/login-screen.dart';
import 'package:final_year_project/screens/signup/signup-screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

import 'screens/welcome/welcome_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Colors.deepOrangeAccent,
              shape: const StadiumBorder(),
              maximumSize: const Size(double.infinity, 56),
              minimumSize: const Size(double.infinity, 56),
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: Colors.white70,
            iconColor: Colors.blue,
            prefixIconColor: Colors.blue,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide.none,
            ),
          )),
      initialRoute: '/',
      routes: {
        '/': (ctx) => const MySplashScreen(),
        '/welcome': (ctx) => WelcomeScreen(),
        '/login': (ctx) => const LoginScreen(),
        '/signup': (ctx) => const SignupScreen(),
        '/home': (ctx) => const TabsScreen(),
        //TODO:Geri kalan yönlendirmeler yapılacak.
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (ctx) => const TabsScreen(),
        );
      },
    );
  }
}
