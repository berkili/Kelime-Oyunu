import 'package:final_year_project/screens/game/widget/myappbar.dart';
import 'package:final_year_project/screens/game/widget/mytext.dart';
import 'package:flutter/material.dart';

class Category extends StatefulWidget {
  const Category({Key? key}) : super(key: key);

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/login_bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: MyAppbar(
            title: "Category",
          ),
        ),
        body: SafeArea(
          child: buildBody(),
        ),
      ),
    );
  }

  buildBody() {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: 4,
        itemBuilder: (BuildContext ctx, index) {
          String categoryTitle;

          if (index == 0) {
            categoryTitle = 'English-Turkish';
          } else if (index == 1) {
            categoryTitle = 'Turkish-English';
          } else if (index == 2) {
            categoryTitle = 'Synonyms';
          } else {
            categoryTitle = 'Antonyms';
          }

          return GestureDetector(
            onTap: () {
              if (index == 0) {
                // English-Turkish kategorisi için sayfa yönlendirmesi
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const Level()),
                // );
              } else if (index == 1) {
                // Turkish-English kategorisi için sayfa yönlendirmesi
                // Diğer kategoriler için de benzer şekilde ekleyebilirsiniz
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const Level()),
                // );
              } else if (index == 2) {
                // Synonyms kategorisi için sayfa yönlendirmesi
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const Level()),
                // );
              } else {
                // Antonyms kategorisi için sayfa yönlendirmesi
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const Level()),
                // );
              }
            },
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 170,
                    height: 170,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 5.0,
                        ),
                      ],
                    ),
                    child: Center(
                      child: MyText(
                        title: categoryTitle,
                        size: 16,
                        fontWeight: FontWeight.w500,
                        colors: const Color(0xFF000000),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
