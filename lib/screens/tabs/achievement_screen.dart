import 'package:flutter/material.dart';

class AchivementScreen extends StatefulWidget {
  const AchivementScreen({super.key});

  @override
  State<AchivementScreen> createState() => _AchivementScreenState();
}

class _AchivementScreenState extends State<AchivementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blueGrey,
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      title: const Text('Başarımlar'),
      centerTitle: true,
      ),
      body: Container(),
    );
  }
}