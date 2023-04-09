import 'package:flutter/material.dart';

class HomeBackground extends StatelessWidget {
  final Widget child;
  const HomeBackground({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          Material(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xff673ab7),
                    Color(0xff8bc34a),
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
            ),
          ),
          SafeArea(
            child: child,
          ),
        ],
      ),
    );
  }
}
