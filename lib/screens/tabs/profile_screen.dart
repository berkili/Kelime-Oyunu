import 'package:final_year_project/screens/home_statistics/widgets/home_background.dart';
import 'package:final_year_project/screens/tabs/model/user.dart';
import 'package:final_year_project/screens/tabs/utils/user_preferances.dart';
import 'package:final_year_project/screens/tabs/widgets/button_widget.dart';
import 'package:final_year_project/screens/tabs/widgets/numbers_widget.dart';
import 'package:final_year_project/screens/tabs/widgets/profile_stat_card.dart';
import 'package:final_year_project/screens/tabs/widgets/profile_widget.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    const user = UserPreferences.myUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text('Profil'),
        centerTitle: true,
      ),
      body: HomeBackground(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 24),
            ProfileWidget(
              imagePath: user.imagePath,
              onClicked: () {},
            ),
            const SizedBox(height: 24),
            buildName(user),
            const SizedBox(height: 24),
            //NumbersWidget(),
            const SizedBox(height: 48),
            buildAbout(user),
          ],
        ),
      ),
    );
  }

  Widget buildName(User user) => Column(
        children: [
          Text(
            user.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          )
        ],
      );

  Widget buildAbout(User user) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: StatCard(
          loseRate: user.winMatch,
          winRate: user.loseMatch,
        ),
      );
}
