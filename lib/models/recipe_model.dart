class RecipeModel {
  String name;
  String author;
  String imageLink;
  List<String> recipeSteps;

  //constructor
  RecipeModel({
    required this.name,
    required this.author,
    required this.imageLink,
    required this.recipeSteps,
  });

  factory RecipeModel.fromJSON(Map<String, dynamic> json) {
    return RecipeModel(
      name: json['name'],
      author: json['author'],
      imageLink: json['imageLink'],
      recipeSteps: List<String>.from(json['recipe']),
    );
  }

  // conversor a JSON
  Map<String, dynamic> toJSON() {
    return {
      'name': name,
      'author': author,
      'imageLink': imageLink,
      'recipe': recipeSteps,
    };
  }

  @override
  String toString() {
    return 'Recipe(name $name, author: $author, imageLink: $imageLink, recipe: $recipeSteps)';
  }
}
