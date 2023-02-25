import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeGameInfo extends StatelessWidget {
  const HomeGameInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => const SizedBox(
          width: 10,
        ),
        itemCount: 3,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {},
          child: SizedBox(
            width: 124,
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      margin: const EdgeInsets.only(
                          left: 15, bottom: 10, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          Text(
                            'Yeni Oyun',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              letterSpacing: 1.3,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Icon(
                            FontAwesomeIcons.circlePlus,
                            color: Colors.black,
                            size: 70,
                          ),
                          SizedBox(width: 1),
                          Text(
                            'Oyna',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
