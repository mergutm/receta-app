import 'dart:convert';
import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http show get;
import 'package:http/http.dart' as http;
import 'package:recipes_app/screens/recipe_details.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<List<dynamic>> fetchRecipes() async {
    // Android 10.0.2.2
    // IOS 127.0.0.1
    // WEB

    String getBaseUrl() {
      if (kIsWeb) {
        // Running in a web browser - assuming server is accessible from browser's perspective
        // This might need adjustment based on how you host/proxy your API for web
        return 'http://localhost:12345'; // Or your domain
      } else if (Platform.isAndroid) {
        // Android Emulator uses 10.0.2.2 to access host localhost
        return 'http://10.0.2.2:12345';
      } else if (Platform.isIOS) {
        // iOS Simulator uses localhost or 127.0.0.1
        return 'http://localhost:12345';
      } else {
        // Default or other platforms (handle physical devices separately)
        // For physical devices, you'd need the host machine's actual network IP
        // e.g., 'http://192.168.1.100:12345'
        // Returning localhost as a fallback might not work universally
        return 'http://localhost:12345';
      }
    }

    final url = Uri.parse('${getBaseUrl()}/recipes');
    //final url = Uri.parse('http://10.0.2.2:12345/recipes');
    //final url = Uri.parse('http://192.168.2.242:12345/recipes');
    //final url = Uri.parse('http://0.0.0.0:12345/recipes');
    //print('Attempting to connect to: $url'); // Helpful for debugging

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['recipes'];
      } else {
        //print('Error ${response.statusCode}');
        return [];
      }
    } catch (e) {
      //print("Errro in request $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    // probando fetchRecipes
    //final data = fetchRecipes();
    //fetchRecipes();

    String getBaseUrl() {
      if (kIsWeb) {
        // Running in a web browser - assuming server is accessible from browser's perspective
        // This might need adjustment based on how you host/proxy your API for web
        return 'http://0.0.0.0:12345'; // Or your domain
      } else if (Platform.isAndroid) {
        // Android Emulator uses 10.0.2.2 to access host localhost
        return 'http://10.0.2.2:12345';
      } else if (Platform.isIOS) {
        // iOS Simulator uses localhost or 127.0.0.1
        return 'http://127.0.0.1:12345';
      } else {
        // Default or other platforms (handle physical devices separately)
        // For physical devices, you'd need the host machine's actual network IP
        // e.g., 'http://192.168.1.100:12345'
        // Returning localhost as a fallback might not work universally
        return 'http://192.168.1.100:12345';
      }
    }

    final url = Uri.parse('${getBaseUrl()}/recipes');

    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      // body: Column(
      //   children: <Widget>[
      //     _recipesCard(context),
      //     _recipesCard(context),
      //     _recipesCard(context),
      //   ],
      // ),
      // body: FutureBuilder(future: fetchRecipes(), builder: () {}),
      body: FutureBuilder<List<dynamic>>(
        future: fetchRecipes(),
        builder: (context, snapshot) {
          //final recipes = snapshot.data;
          final recipes = snapshot.data ?? [];
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error al cargar recetas: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No se encontró información en $url"));
          }

          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              return _recipesCard(context, recipes[index]);
            },
          );
        },
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

  Widget _recipesCard(BuildContext context, dynamic recipe) {
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetails(recipeName: recipe['name']),
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
                      //'https://myplate-prod.azureedge.us/sites/default/files/styles/recipe_525_x_350_/public/2022-01/Noodles_1.jpg?itok=D8SbUIWg',
                      //'https://www.excelsior.com.mx/800x600/filters:format(webp):quality(75)/media/pictures/2025/05/03/3301163.jpg',
                      recipe['image_link'],
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
                      recipe['name'],
                      style: TextStyle(fontSize: 16, fontFamily: 'QuickSand'),
                    ),
                    Container(width: 100, height: 3, color: colors.primary),
                    SizedBox(height: 5),
                    Text(
                      recipe['author'],
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
