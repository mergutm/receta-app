import 'dart:convert';
import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http show get;
import 'package:http/http.dart' as http;
import 'package:recipes_app/screens/recipe_details.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<List<dynamic>> fetchRecipes() async {
    // Android 10.0.2.2
    // IOS 127.0.0.1
    // WEB
    //final url = Uri.parse('http://10.0.2.2:12346/recipes');
    final url = Uri.parse('http://0.0.0.0:3001/recipes');
    final response = await http.get(url);
    final data = jsonDecode(response.body);
    return data['recipes'];
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: Column(
        children: <Widget>[
          _recipesCard(context),
          _recipesCard(context),
          _recipesCard(context),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showButton(context);
        },
        backgroundColor: colors.primary,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Future<void> _showButton(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder:
          (_) => Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            height: 500,
            child: FormularioReceta(),
          ),
    );
  }

  Widget _recipesCard(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetails(recipeName: "Pasta"),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 125,
          child: Card(
            child: Row(
              children: <Widget>[
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: colors.tertiary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      'https://myplate-prod.azureedge.us/sites/default/files/styles/recipe_525_x_350_/public/2022-01/Noodles_1.jpg?itok=D8SbUIWg',
                      //'https://www.excelsior.com.mx/800x600/filters:format(webp):quality(75)/media/pictures/2025/05/03/3301163.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  // child: ClipRRect(
                  //   borderRadius: BorderRadius.circular(10),
                  //   child: Container(),
                  //   //child: Text("rpu"),
                  // ),
                ),
                SizedBox(width: 20, height: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Frijoles charros",
                      style: TextStyle(fontSize: 16, fontFamily: 'QuickSand'),
                    ),
                    Container(width: 100, height: 3, color: colors.primary),
                    SizedBox(height: 5),
                    Text(
                      "Caroline",
                      style: TextStyle(fontSize: 12, fontFamily: 'QuickSand'),
                    ),
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

class FormularioReceta extends StatelessWidget {
  FormularioReceta({super.key});

  //controlador
  final TextEditingController _recipeName = TextEditingController();
  final TextEditingController _recipeAuthor = TextEditingController();
  final TextEditingController _recipeURL = TextEditingController();
  final TextEditingController _recipeDescription = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Nueva receta",
              style: TextStyle(color: colors.primary, fontSize: 20),
            ),
            SizedBox(height: 10),
            _buildTextField(
              controller: _recipeName,
              context: context,
              label: "Nombre de la receta",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Introduce el nombre de la receta';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            _buildTextField(
              controller: _recipeAuthor,
              context: context,
              label: "Autor de la receta",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Introduce el nombre del autor';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            _buildTextField(
              controller: _recipeURL,
              context: context,
              label: "URL de la imagen",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Introduce la URL de la imagen';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            _buildTextField(
              controller: _recipeDescription,
              context: context,
              label: "Descripción",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Introduce la descripción';
                }
                return null;
              },
              maxLines: 4,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Guardar receta",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String? Function(String?) validator,
    required TextEditingController controller,
    required BuildContext context,
    required String label,
    int maxLines = 1,
  }) {
    final colors = Theme.of(context).colorScheme;
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontFamily: 'QuickSand', color: colors.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colors.tertiary, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: validator,
      maxLines: maxLines,
    );
  }
}
