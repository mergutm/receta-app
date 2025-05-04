import 'package:flutter/material.dart';

class RecipeDetails extends StatelessWidget {
  final String recipeName;

  const RecipeDetails({super.key, required this.recipeName});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(recipeName),
        leading: IconButton(
          color: colors.primary,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
    );
  }
}
