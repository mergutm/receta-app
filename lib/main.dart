import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/providers/recipe_providers.dart';
import 'package:recipes_app/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => RecipeProviders())],
      child: MaterialApp(
        title: 'Recetario',
        home: Recetario(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class Recetario extends StatelessWidget {
  const Recetario({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: colors.primary,
          title: Text("Recetario ...", style: TextStyle(color: Colors.white)),
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: colors.tertiary,
            tabs: <Widget>[Tab(icon: Icon(Icons.home), text: 'Inicio')],
          ),
        ),
        body: //HomeScreen(),
            TabBarView(children: [HomeScreen()]),
      ),
    );
  }
}
