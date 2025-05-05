import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/models/recipe_model.dart';
import 'package:recipes_app/providers/recipe_providers.dart';
import 'package:recipes_app/screens/recipe_details.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //return Center(child: Text("Favoritos"));
    return Scaffold(
      backgroundColor: Colors.white,
      //appBar: AppBar(),
      body: Consumer<RecipeProviders>(
        builder: (context, recipeProviders, child) {
          final favoriteRecipes = recipeProviders.favoriteRecipes;

          return favoriteRecipes.isEmpty
              ? Center(child: Text("No favorite recipes"))
              : ListView.builder(
                itemCount: favoriteRecipes.length,
                itemBuilder: (context, index) {
                  final recipe = favoriteRecipes[index];
                  return FavoriteRecipesCard(recipe: recipe);
                },
              );
        },
      ),
    );
  }
}

class FavoriteRecipesCard extends StatelessWidget {
  final RecipeModel recipe;
  const FavoriteRecipesCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetails(recipesData: recipe),
          ),
        );
      },
      child: Card(
        color: Colors.white,
        child: Column(children: [Text(recipe.name), Text(recipe.author)]),
      ),
    );
  }
}
