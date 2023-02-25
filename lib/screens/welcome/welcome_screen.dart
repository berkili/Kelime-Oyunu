import 'package:final_year_project/screens/welcome/widgets/background.dart';
import 'package:final_year_project/screens/welcome/widgets/welcome_buttons.dart';
import 'package:final_year_project/screens/welcome/widgets/welcome_text.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(children: [
                const WelcomeText(),
                Row(
                  children: const [
                    Spacer(),
                    Expanded(
                      flex: 8,
                      child: WelcomeButtons(),
                    ),
                    Spacer(),
                  ],
                )
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
