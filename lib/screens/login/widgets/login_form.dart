import 'package:final_year_project/screens/login/forgot_password_screen.dart';
import 'package:final_year_project/screens/socket/socketManager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../home_statistics/tabs_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

//TODO: Giriş yapılırken uyarılar ekranda gösterilmeli(Bkn. signup_form.dart)
class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _signInWithEmailAndPassword() async {
    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (userCredential.user != null) {
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        final loginDocument = await firestore.collection("login").add(
          {
            "userId": userCredential.user!.uid,
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
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('Böyle bir kullanıcı bulunamadı');
      } else if (e.code == 'wrong-password') {
        print('Yanlış şifre');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Yanlış şifre"),
        ));
      }
    } catch (e) {
      print(e);
      SocketManager.disconnect();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Bağlanırken bir hata oluştu."),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: Colors.black,
            onSaved: (email) {},
            decoration: const InputDecoration(
              hintText: "abc@abc.com",
              prefixIcon: Padding(
                padding: EdgeInsets.all(16.0),
                child: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: TextFormField(
              controller: _passwordController,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: Colors.black,
              decoration: const InputDecoration(
                hintText: "Şifre",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ForgotPasswordScreen()),
              );
            },
            child: const Text(
              "Şifremi unuttum",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Hero(
            tag: "login_btn",
            child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  try {
                    await _signInWithEmailAndPassword();
                  } catch (e) {
                    print(e);
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text(
                "Giriş Yap",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
