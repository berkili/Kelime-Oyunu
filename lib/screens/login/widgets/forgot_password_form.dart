import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Şifremi sıfırlama işlemi
Future<void> resetPassword(String email) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  } catch (e) {
    print(e);
  }
}

class ForgotPassForm extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  ForgotPassForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'E-posta',
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        ElevatedButton(
          onPressed: () {
            resetPassword(_emailController.text);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Şifre sıfırlama e-postası gönderildi.'),
              ),
            );
          },
          child: const Text('Şifremi Sıfırla'),
        ),
      ],
    );
  }
}
