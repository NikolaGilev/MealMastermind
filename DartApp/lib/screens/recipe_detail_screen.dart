import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/api_service.dart';
import 'map_screen.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;

  RecipeDetailScreen({required this.recipe});

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  final APIService apiService = APIService();
  late bool _isLiked;
  late int _likes;
  late List<Map<String, dynamic>> _comments;

  @override
  void initState() {
    super.initState();
    _isLiked = false;
    _likes = widget.recipe.likes ?? 0; // Handle potential null value
    _comments = widget.recipe.comments ?? []; // Handle potential null value
  }

  void _toggleLike() async {
    setState(() {
      _isLiked = !_isLiked;
      _likes += _isLiked ? 1 : -1;
    });

    // Update likes on the server
    bool success = await apiService.updateLikes(widget.recipe.id, _isLiked ? 1 : -1);
    if (!success) {
      setState(() {
        _isLiked = !_isLiked; // Revert state if API call fails
        _likes += _isLiked ? 1 : -1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            pinned: true,
            actions: [
              IconButton(
                icon: Icon(
                  _isLiked ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
                onPressed: _toggleLike,
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.recipe.title ?? 'Recipe'),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  widget.recipe.imageUrl != null
                      ? Image.network(
                    widget.recipe.imageUrl!,
                    fit: BoxFit.cover,
                  )
                      : Container(color: Colors.grey), // Handle potential null value
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0.0, 0.8),
                        end: Alignment(0.0, 0.0),
                        colors: <Color>[
                          Color(0x60000000),
                          Color(0x00000000),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recipe Title and Times
                  Text(
                    widget.recipe.title ?? 'Recipe Title',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Text(
                        'Prep Time: ${widget.recipe.preparationTime ?? 0} mins · Total Time: 10 mins',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16.0,
                        ),
                      ),
                      Spacer(),
                      Text(
                        '$_likes likes',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),

                  // Nutritional Info with enhanced styling
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNutritionalInfo('Calories', widget.recipe.nutritionalInfo?['calories'].toString() ?? '0'),
                      _buildNutritionalInfo('Protein', widget.recipe.nutritionalInfo?['protein'].toString() ?? '0'),
                      _buildNutritionalInfo('Carbs', widget.recipe.nutritionalInfo?['carbs'].toString() ?? '0'),
                      _buildNutritionalInfo('Fats', widget.recipe.nutritionalInfo?['fat'].toString() ?? '0'),
                    ],
                  ),

                  const SizedBox(height: 16.0),

                  // Description
                  Text(
                    widget.recipe.description ?? 'No description available.',
                    style: TextStyle(fontSize: 16.0),
                  ),

                  const SizedBox(height: 16.0),

                  // Ingredients Section
                  Text(
                    'Ingredients',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  ...?widget.recipe.ingredients?.map((ingredient) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      '${ingredient['name']}: ${ingredient['grams']}g',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  )) ?? [],

                  const SizedBox(height: 16.0),

                  // Directions Section with numbered steps
                  Text(
                    'Directions',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  ...List.generate(
                    widget.recipe.instructions?.length ?? 0,
                        (index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        '${index + 1}. ${widget.recipe.instructions?[index] ?? ''}',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16.0),

                  // Comments Section
                  Text(
                    'Comments',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  ..._comments.map((comment) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          comment['author']?.substring(0, 2).toUpperCase() ?? 'NA',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.orange,
                      ),
                      title: Text(comment['author'] ?? 'Unknown'),
                      subtitle: Text(comment['content'] ?? 'No content'),
                      trailing: Text(
                        comment['date'] ?? 'N/A',
                        style: TextStyle(fontSize: 12.0, color: Colors.grey),
                      ),
                    ),
                  )),

                  // Add Comment Section
                  const SizedBox(height: 16.0),
                  _buildAddCommentSection(context),

                  // Location Section
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.red),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MapScreen(
                                latitude: double.tryParse(widget.recipe.latitude) ?? 0.0,
                                longitude: double.tryParse(widget.recipe.longitude) ?? 0.0,
                              ),
                            ),
                          );
                        },
                        child: Text('View on Map'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionalInfo(String label, String value) {
    return Container(
      width: 70,
      height: 70,
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddCommentSection(BuildContext context) {
    final TextEditingController _commentController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _commentController,
          decoration: InputDecoration(
            labelText: 'Add a comment...',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8.0),
        ElevatedButton(
          onPressed: () async {
            String newComment = _commentController.text;
            if (newComment.isNotEmpty) {
              // Add comment using API service
              bool success = await apiService.addComment(widget.recipe.id, 'Current User', newComment);
              if (success) {
                setState(() {
                  _comments.add({
                    'author': 'Current User',
                    'content': newComment,
                    'date': DateTime.now().toString().split(' ')[0],
                  });
                });
                _commentController.clear();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to add comment.')),
                );
              }
            }
          },
          child: Text('Post Comment'),
        ),
      ],
    );
  }
}
