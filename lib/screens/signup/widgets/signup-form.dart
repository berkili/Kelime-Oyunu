import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../home_statistics/tabs_screen.dart';

//TODO: Kayıt olduktan sonra oto giriş yapmasın.

class SignupForm extends StatefulWidget {
  SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _passwordConfirmationError;
  String? _passwordLengthError;
  String? _emailValidateError;

  String? _validatePasswordConfirmation(String? value) {
    if (value != _passwordController.text) {
      return 'Şifreler eşleşmiyor';
    }
    return null;
  }

  String? _validatePasswordLength(String? value) {
    if (value!.length < 6) {
      return 'Şifre en az 6 karakter olmalıdır';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
      return 'Lütfen geçerli bir e-posta adresi girin.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            validator: _validateEmail,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: Colors.black,
            onSaved: (email) {},
            decoration: const InputDecoration(
              hintText: "E-mail Adresi",
              prefixIcon: Padding(
                padding: EdgeInsets.all(16.0),
                child: Icon(Icons.person),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _emailValidateError = _validateEmail(value);
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: TextFormField(
              validator: _validatePasswordLength,
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
              onChanged: (value) {
                setState(() {
                  _passwordLengthError = _validatePasswordLength(value);
                });
              },
            ),
          ),
          TextFormField(
            validator: _validatePasswordConfirmation,
            controller: _confirmPasswordController,
            textInputAction: TextInputAction.done,
            obscureText: true,
            cursorColor: Colors.black,
            decoration: const InputDecoration(
              hintText: "Tekrar Şifre",
              prefixIcon: Padding(
                padding: EdgeInsets.all(16.0),
                child: Icon(Icons.lock),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _passwordConfirmationError =
                    _validatePasswordConfirmation(value);
              });
            },
          ),
          if (_passwordConfirmationError != null)
            Text(
              _passwordConfirmationError!,
              style: const TextStyle(color: Colors.red),
            ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () async {
              setState(() {
                _passwordConfirmationError = _validatePasswordConfirmation(
                    _confirmPasswordController.text);
              });

              if (_formKey.currentState!.validate() &&
                  _passwordConfirmationError == null &&
                  _passwordLengthError == null &&
                  _emailValidateError == null) {
                if (_formKey.currentState!.validate()) {
                  try {
                    final newUser = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: _emailController.text.trim(),
                      password: _passwordController.text,
                    )
                        .then(
                      (value) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TabsScreen()),
                        );
                      },
                    );
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      print('The password provided is too weak.');
                    } else if (e.code == 'email-already-in-use') {
                      print(
                          'Bu email başka kullanıcı tarafından kullanılıyor.');
                    }
                  } catch (e) {
                    print(e);
                  }
                }
              }
            },
            child: const Text(
              "Kayıt Ol",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
