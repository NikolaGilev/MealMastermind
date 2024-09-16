import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
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

  Future<bool> postRecipe(Recipe recipe, File? imageFile) async {
    var request = http.MultipartRequest('POST', Uri.parse('$apiUrl/recipes'));

    request.fields['id'] = recipe.id.toString();
    request.fields['title'] = recipe.title;
    request.fields['author'] = recipe.author;
    request.fields['description'] = recipe.description;
    request.fields['datePosted'] = recipe.datePosted;
    request.fields['preparationTime'] = recipe.preparationTime.toString();
    request.fields['likes'] = recipe.likes.toString();
    request.fields['ingredients'] = json.encode(recipe.ingredients);
    request.fields['instructions'] = json.encode(recipe.instructions);
    request.fields['nutritionalInfo'] = json.encode(recipe.nutritionalInfo);
    request.fields['rating'] = recipe.rating.toString();
    request.fields['longitude'] = recipe.longitude.toString();
    request.fields['latitude'] = recipe.latitude.toString();

    if (imageFile != null) {
      var pic = await http.MultipartFile.fromPath('image', imageFile.path);
      request.files.add(pic);
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  // Method to update likes for a recipe
  Future<bool> updateLikes(int recipeId, int increment) async {
    final response = await http.post(
      Uri.parse('$apiUrl/recipes/$recipeId/likes'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'increment': increment}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Failed to update likes: ${response.statusCode}');
      return false;
    }
  }

  // Method to add a comment to a recipe
  Future<bool> addComment(int recipeId, String author, String content) async {
    final response = await http.post(
      Uri.parse('$apiUrl/recipes/$recipeId/comments'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'author': author, 'content': content, "date": DateTime.now().toString().split(' ')[0]}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Failed to add comment: ${response.statusCode}');
      return false;
    }
  }


}
