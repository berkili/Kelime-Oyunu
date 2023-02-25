import 'package:final_year_project/screens/tabs/account_screen.dart';
import 'package:final_year_project/screens/tabs/widgets/icon_style.dart';
import 'package:final_year_project/screens/tabs/widgets/settingsUserCard.dart';
import 'package:final_year_project/screens/tabs/widgets/settings_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    var divider = const Divider(
      height: 1,
      thickness: 2,
      indent: 2,
      endIndent: 2,
      color: Colors.black,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text('Ayarlar'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {},
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(19),
        child: ListView(children: [
          SettingsUserCard(
            SettingsItem(
              icons: Icons.edit,
              iconStyle: IconStyle(                
                withBackground: true,
                borderRadius: 50,
                backgroundColor: Colors.grey[500],
              ),              
              title: "Düzenle",
              subtitle: "Bilgilerinizi değiştirmek için tıkla!",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AccountScreen(),
                  ),
                );
              },
            ),
          ),
          divider,
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Tercihler",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          divider,
          SettingsItem(
            onTap: () {},
            icons: Icons.volume_up,
            iconStyle: IconStyle(
              iconsColor: Colors.black,
              withBackground: true,
              backgroundColor: Colors.transparent,
            ),
            title: 'Ses',
            subtitle: "Oyundaki sesi açar/kapatır.",
            trailing: Switch.adaptive(
              value: false,
              onChanged: (value) {},
            ),
          ),
          SettingsItem(
            onTap: () {},
            icons: Icons.music_note_outlined,
            iconStyle: IconStyle(
              iconsColor: Colors.black,
              withBackground: true,
              backgroundColor: Colors.transparent,
            ),
            title: 'Müzik',
            subtitle: "Oyundaki müziği açar/kapatır.",
            trailing: Switch.adaptive(
              value: false,
              onChanged: (value) {},
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          divider,
        ]),
      ),
    );
  }
}
