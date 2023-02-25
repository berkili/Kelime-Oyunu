import 'package:flutter/material.dart';

class WelcomeText extends StatelessWidget {
  const WelcomeText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Uygulama Adı",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        const SizedBox(height: 16.0 * 20),
        Flex(
          direction: Axis.horizontal,
          children: const [
            Spacer(),
            Expanded(
              flex: 0,
              child: Text(
                "Oynamak için giriş yap",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            Spacer(),
          ],
        ),
        const SizedBox(height: 12.0 * 2),
      ],
    );
  }
}
