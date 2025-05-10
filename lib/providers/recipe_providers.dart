import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
//import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recipes_app/models/recipe_model.dart';

class RecipeProviders extends ChangeNotifier {
  bool isLoading = false;

  List<RecipeModel> recipes = [];
  List<RecipeModel> favoriteRecipes = [];

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

  Future<void> fetchRecipes() async {
    isLoading = true;
    notifyListeners();
    // Android 10.0.2.2
    // IOS 127.0.0.1
    // WEB

    final url = Uri.parse('${getBaseUrl()}/recipes');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        //return data['recipes'];
        recipes = List<RecipeModel>.from(
          data['recipes'].map((recipe) => RecipeModel.fromJSON(recipe)),
        );
      } else {
        //print('Error ${response.statusCode}');
        //return [];
        recipes = [];
      }
    } catch (e) {
      //print("Errro in request $e");
      //return [];
      recipes = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavoriteStatus(RecipeModel recipe) async {
    final isFavorite = favoriteRecipes.contains(recipe);

    try {
      final url = Uri.parse('${getBaseUrl()}/favorites');
      //final url = Uri.parse(url);
      final response =
          isFavorite
              ? await http.delete(url, body: json.encode({"id": recipe.id}))
              : await http.post(url, body: json.encode(recipe.toJSON()));

      if (response.statusCode == 200) {
        if (isFavorite) {
          favoriteRecipes.remove(recipe);
        } else {
          favoriteRecipes.add(recipe);
          //print(favoriteRecipes);
        }
        notifyListeners();
      } else {
        throw Exception("Failure while updating favorite recipes");
      }
    } catch (e) {
      //print("Error updating favorite recipes $e");
    }
  }
}
