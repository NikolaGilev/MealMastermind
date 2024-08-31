import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:meal_mastermind/models/recipe.dart';
import 'package:meal_mastermind/utils/constants.dart';

class APIService {
  static final APIService _instance = APIService._internal();

  factory APIService() => _instance;

  APIService._internal();

  Future<List<Recipe>> fetchRecipes() async {
    final response = await http.get(Uri.parse('$apiUrl/recipes'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map<Recipe>((json) => Recipe.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  Future<List<Recipe>> fetchRandomRecipes() async {
    final response = await http.get(Uri.parse('$apiUrl/random-recipes'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map<Recipe>((json) => Recipe.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load random recipes');
    }
  }

  Future<List<Recipe>> searchRecipes(String query) async {
    final response = await http.get(Uri.parse('$apiUrl/recipes/search?q=$query'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map<Recipe>((json) => Recipe.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search recipes');
    }
  }

  Future<Recipe> fetchRecipeDetails(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/recipes/$id'));
    if (response.statusCode == 200) {
      return Recipe.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load recipe details');
    }
  }
}
