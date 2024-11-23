import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<dynamic>> fetchMeals() async {
  final response = await http.get(
    Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?f=a'),
  );

  if (response.statusCode == 200) {
    return json.decode(response.body)['meals'];
  } else {
    throw Exception('Failed to load meals');
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 235, 233), // Set background color
      appBar: AppBar(
        title: const Text('Meal List'),
        backgroundColor: const Color.fromARGB(255, 234, 200, 226), // AppBar color
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchMeals(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final meals = snapshot.data!;
            return ListView.builder(
              itemCount: meals.length,
              itemBuilder: (context, index) {
                final meal = meals[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                  child: ExpansionTile(
                    title: Text(
                      meal['strMeal'],
                      style: TextStyle(
                        fontSize: 22, 
                        fontFamily: 'Poppins', 
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    leading: Image.network(
                      meal['strMealThumb'],
                      height: 300, 
                      width: 300,  
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          meal['strInstructions'], // Full description
                          style: TextStyle(
                            fontSize: 18, 
                            fontFamily: 'Poppins', 
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: HomeScreen()));
}
