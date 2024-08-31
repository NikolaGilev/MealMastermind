import 'dart:convert';

class Recipe {
  final int id;
  final String title;
  final String author;
  final String description;
  final String datePosted;
  final String preparationTime;
  final String likes;
  final String imageUrl;
  final String ingredients;
  final String instructions;
  final String nutritionalInfo;
  final double rating;

  Recipe({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.datePosted,
    required this.preparationTime,
    required this.likes,
    required this.imageUrl,
    required this.ingredients,
    required this.instructions,
    required this.nutritionalInfo,
    required this.rating,
  });
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      description: json['description'],
      datePosted: json['datePosted'],
      preparationTime: json['preparationTime'],
      likes: json['likes'],
      imageUrl: json['imageUrl'],
      ingredients: json['ingredients'],
      instructions: json['instructions'],
      nutritionalInfo: json['nutritionalInfo'],
      rating: json['rating'].toDouble(),
    );
  }

  static Map<String, dynamic> toMap(Recipe recipe) => {
    'id': recipe.id,
    'title': recipe.title,
    'author': recipe.author,
    'description': recipe.description,
    'datePosted': recipe.datePosted,
    'preparationTime': recipe.preparationTime,
    'likes': recipe.likes,
    'imageUrl': recipe.imageUrl,
    'ingredients': recipe.ingredients,
    'instructions': recipe.instructions,
    'nutritionalInfo': recipe.nutritionalInfo,
    'rating': recipe.rating,
  };

  static String encode(List<Recipe> recipes) => json.encode(
    recipes.map<Map<String, dynamic>>((recipe) => Recipe.toMap(recipe)).toList(),
  );

  static List<Recipe> decode(String recipes) =>
      (json.decode(recipes) as List<dynamic>).map<Recipe>((item) => Recipe.fromJson(item)).toList();
}
