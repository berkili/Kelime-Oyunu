import 'package:final_year_project/screens/home_statistics/home_screen.dart';
import 'package:final_year_project/screens/home_statistics/statistics_screen.dart';
import 'package:final_year_project/screens/tabs/achievement_screen.dart';
import 'package:final_year_project/screens/tabs/profile_screen.dart';
import 'package:final_year_project/screens/tabs/settings_screen.dart';
import 'package:final_year_project/screens/welcome/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  List<Map<String, Object>>? _pages;
  int _selectedPageIndex = 0;

  //TODO: Multi list olayını öğren ve aşağıdaki iki fonkisyonu birleştir.
  final _pageOptions = [
    const HomeScreen(),
    const StatisticsScreen(),
  ];

  final _titles = [
    "Spinning Quiz",
    "Sıralama",
  ];

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  Widget buildListTile(String title, IconData icon, Function() tapHandler) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'RobotoCondensed',
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: tapHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        titleSpacing: 0.0,
        title: Text(_titles[_selectedPageIndex]),
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => _globalKey.currentState?.openEndDrawer(),
              ),
            ],
          )
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.transparent),
              child: Text(
                'Spinning Quiz',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 40,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            buildListTile(
              'Profil',
              FontAwesomeIcons.user,
              (() {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              }),
            ),
            // buildListTile(
            //   'Başarımlar',
            //   FontAwesomeIcons.trophy,
            //   (() {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => const AchivementScreen(),
            //       ),
            //     );
            //   }),
            // ),
            buildListTile(
              'Ayarlar',
              Icons.settings,
              (() {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              }),
            ),
            buildListTile(
              'Çıkış Yap',
              Icons.exit_to_app,
              (() {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WelcomeScreen(),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      body: _pageOptions[_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        iconSize: 30,
        backgroundColor: Colors.blueGrey,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.black,
        currentIndex: _selectedPageIndex,
        // type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: const Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: const Icon(Icons.bar_chart),
            label: 'Sıralama',
          ),
        ],
      ),
    );
  }
}
