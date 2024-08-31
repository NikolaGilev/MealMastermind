class User {
  final int id;
  final String name;
  final String email;
  final List<int> favoriteRecipes;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.favoriteRecipes,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      favoriteRecipes: List<int>.from(json['favoriteRecipes']),
    );
  }
}
