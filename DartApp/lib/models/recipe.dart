import 'dart:convert';

class Recipe {
  final int id;
  final String title;
  final String author;
  final String description;
  final String datePosted;
  final int preparationTime;
  final int likes;
  final String imageUrl;
  final List<Map<String, dynamic>> ingredients;
  final List<String> instructions;
  final Map<String, dynamic> nutritionalInfo;
  final double rating;
  final List<Map<String, dynamic>> comments; // New field for comments

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
    this.comments = const [], // Initialize comments as empty list by default
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
      ingredients: List<Map<String, dynamic>>.from(json['ingredients'] ?? []),
      instructions: List<String>.from(json['instructions'] ?? []),
      nutritionalInfo: Map<String, dynamic>.from(json['nutritionalInfo'] ?? {}),
      comments: List<Map<String, dynamic>>.from(json['comments'] ?? []), // Provide default empty list if null
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
    'comments': recipe.comments, // Convert comments to JSON
    'rating': recipe.rating,
  };

  static String encode(List<Recipe> recipes) => json.encode(
    recipes.map<Map<String, dynamic>>((recipe) => Recipe.toMap(recipe)).toList(),
  );

  static List<Recipe> decode(String recipes) =>
      (json.decode(recipes) as List<dynamic>)
          .map<Recipe>((item) => Recipe.fromJson(item))
          .toList();
}
