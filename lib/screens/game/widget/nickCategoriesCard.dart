import 'package:flutter/material.dart';

class NickAndCategoriesCard extends StatelessWidget {
  final String? player1Name;
  final String? player2Name;
  final List<String> categories;

  const NickAndCategoriesCard({
    super.key,
    required this.player1Name,
    required this.player2Name,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Card(
            color: Colors.blue,
            elevation: 4,
            margin: const EdgeInsets.all(8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPlayerCard(player1Name!),
                  _buildCategories(),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: Card(
            color: Colors.redAccent,
            elevation: 4,
            margin: const EdgeInsets.all(8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPlayerCard(player2Name!),
                  _buildCategories(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerCard(String playerName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            playerName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        Column(
          children: categories
              .map((categoryName) => _buildCategoryItem(categoryName))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(String categoryName) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        categoryName,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return const SizedBox(height: 16.0);
  }
}
