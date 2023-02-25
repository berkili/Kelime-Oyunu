import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blueGrey,
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      title: const Text('Profil'),
      centerTitle: true,
      ),
      body: Container(),
    );
  }
}