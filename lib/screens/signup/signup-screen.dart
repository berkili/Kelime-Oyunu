import 'package:final_year_project/screens/signup/widgets/signup-form.dart';
import 'package:final_year_project/widgets/main_background.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text("Spinning Quiz"),
        centerTitle: true,
      ),
      body: MainBackground(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: const [
                  Spacer(),
                  Expanded(
                    flex: 8,
                    child: SignupForm(),
                  ),
                  Spacer(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
