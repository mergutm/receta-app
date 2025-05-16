import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/models/recipe_model.dart';
import 'package:recipes_app/providers/recipe_providers.dart';
import 'package:recipes_app/screens/recipe_details.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
              ? Center(child: Text(AppLocalizations.of(context)!.no_recipes))
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
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetails(recipesData: recipe),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Semantics(
          label: 'Tarjeta de recetas',
          hint: 'Toca para ver el detalle de la receta ${recipe.name}',
          child: Card(
            color: Colors.white,
            //child: Row(children: [Text(recipe.name), Text(recipe.author)]),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(color: Colors.amberAccent),
                  height: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(recipe.imageLink, fit: BoxFit.cover),
                  ),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      recipe.name,
                      style: TextStyle(fontSize: 18, fontFamily: 'QuikSand'),
                    ),
                    Container(
                      color: colors.primary,
                      height: 2,
                      width: size.width * 0.5,
                    ),
                    SizedBox(height: 12),
                    Text("By ${recipe.author}", style: TextStyle(fontSize: 14)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
