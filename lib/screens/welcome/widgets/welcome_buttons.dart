import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project/screens/home_statistics/tabs_screen.dart';
import 'package:final_year_project/screens/login/login-screen.dart';
import 'package:final_year_project/screens/signup/signup-screen.dart';
import 'package:final_year_project/screens/socket/socketManager.dart';
import 'package:final_year_project/screens/welcome/widgets/or-divider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class WelcomeButtons extends StatefulWidget {
  const WelcomeButtons({
    Key? key,
  }) : super(key: key);

  @override
  State<WelcomeButtons> createState() => _WelcomeButtonsState();
}

//TODO: HATAYI TOAST'LA GÖSTER

class _WelcomeButtonsState extends State<WelcomeButtons> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      return user;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            try {
              User? user = await signInWithGoogle();
              if (user != null) {
                FirebaseFirestore firestore = FirebaseFirestore.instance;
                final loginDocument = await firestore.collection("login").add(
                  {
                    "userId": user.uid,
                    "used": false,
                    // "active": false,
                  },
                );
                await SocketManager.connect(loginDocument.id);
                // ignore: use_build_context_synchronously
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TabsScreen(),
                  ),
                );
              }
            } catch (e) {
              print(e);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white70,
            minimumSize: const Size.fromHeight(50),
            textStyle: const TextStyle(fontSize: 18),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Image(
                image: AssetImage("assets/images/google-logo.png"),
                height: 18.0,
                width: 24,
              ),
              Padding(
                padding: EdgeInsets.only(left: 24, right: 8),
                child: Text(
                  'Google ile giriş yap',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16.0 * 1),
        // ElevatedButton(
        //   onPressed: () {},
        //   style: ElevatedButton.styleFrom(
        //     backgroundColor: Colors.white70,
        //     minimumSize: const Size.fromHeight(50),
        //     textStyle: const TextStyle(fontSize: 18),
        //   ),
        //   child: Row(
        //     mainAxisSize: MainAxisSize.min,
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: const [
        //       Image(
        //         image: AssetImage("assets/images/microsoft-logo.png"),
        //         height: 18.0,
        //         width: 24,
        //       ),
        //       Padding(
        //         padding: EdgeInsets.only(left: 24, right: 8),
        //         child: Text(
        //           'Microsoft ile giriş yap',
        //           style: TextStyle(
        //             color: Colors.black,
        //             fontSize: 20,
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        // const SizedBox(height: 16.0 * 1),
        Hero(
          tag: "login_btn",
          child: ElevatedButton.icon(
            icon: const Icon(
              Icons.email,
              color: Colors.black54,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen();
                  },
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white70,
              minimumSize: const Size.fromHeight(50),
              textStyle: const TextStyle(fontSize: 18),
            ),
            label: const Text("E-posta adresi ile giriş yap",
                style: TextStyle(
                  color: Colors.black,
                )),
          ),
        ),
        const SizedBox(height: 16),
        const OrDivider(),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const SignupScreen();
                },
              ),
            );
          },
          style: TextButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            textStyle: const TextStyle(fontSize: 18),
          ),
          child: const Text(
            "Kayıt Ol",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
