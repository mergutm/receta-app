import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/models/recipe_model.dart';
import 'package:recipes_app/providers/recipe_providers.dart';

class RecipeDetails extends StatefulWidget {
  final RecipeModel recipesData;

  const RecipeDetails({super.key, required this.recipesData});

  @override
  RecipeDetailsState createState() => RecipeDetailsState();
}

class RecipeDetailsState extends State<RecipeDetails>
    with SingleTickerProviderStateMixin {
  bool isFavorite = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    //iniciar la animación
    super.initState();
    //controlar inicio y fin de la animación
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    // Controlar lo que pasa durante la animación.
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _scaleAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    //terminar la animación
    _controller.dispose();
    //constructor
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isFavorite = Provider.of<RecipeProviders>(
      context,
      listen: false,
    ).favoriteRecipes.contains(widget.recipesData);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.primary,
        title: Text(
          widget.recipesData.name,
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await Provider.of<RecipeProviders>(
                context,
                listen: false,
              ).toggleFavoriteStatus(widget.recipesData);
              setState(() {
                isFavorite = !isFavorite;
              });
            },
            // icon: Icon(
            //   isFavorite ? Icons.favorite : Icons.favorite_border,
            //   color: Colors.white,
            // ),

            // cambia por la animación definida
            // icon: AnimatedSwitcher(
            //   duration: Duration(milliseconds: 300),
            icon: ScaleTransition(
              scale: _scaleAnimation,
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,

                ///color: isFavorite ? Colors.white : Colors.amber,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),

      body: Padding(
        padding: EdgeInsets.all(25),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Padding(
              //padding: EdgeInsets.all(20),
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Image.network(widget.recipesData.imageLink),
            ),
            SizedBox(height: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.recipesData.name,
                  style: TextStyle(
                    fontFamily: 'Montserat',
                    fontSize: 20,
                    color: colors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text("By ${widget.recipesData.author}"),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  color: Theme.of(context).colorScheme.primary,
                  height: 3,
                ),
                SizedBox(height: 10),
                Text("Pasos:"),
                for (var line in widget.recipesData.recipeSteps)
                  Text(" - $line"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// class RecipeDetails extends StatelessWidget {
//   final String recipeName;

//   const RecipeDetails({super.key, required this.recipeName});

//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(recipeName),
//         leading: IconButton(
//           color: colors.primary,
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Icon(Icons.arrow_back),
//         ),
//       ),
//     );
//   }
// }
