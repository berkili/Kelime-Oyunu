import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:final_year_project/screens/game/theme/color.dart';

class MyAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double? height;

  const MyAppbar({
    Key? key,
    required this.title,
    this.height,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(height!);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60.0),
      child: AppBar(
        title: Text(
          title,
          style: GoogleFonts.poppins(
              color: white, fontSize: 20, fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
          onPressed: () => showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Çıkmak istiyor musunuz?'),
              content:
                  const Text('Oyundan çıkmak istediğinizden emin misiniz?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Evet'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/HomeScreen',
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
                TextButton(
                  child: const Text('Hayır'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
