import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
    return Padding(
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
    );
  }
}

class FormularioReceta extends StatelessWidget {
  const FormularioReceta({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        //key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Nueva receta",
              style: TextStyle(color: colors.primary, fontSize: 20),
            ),
            SizedBox(height: 10),
            _buildTextField(label: "Nombre de la receta"),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required String label}) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontFamily: 'QuickSand', color: Colors.orange),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
