import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/api_service.dart';
import '../widgets/search_bar.dart';
import '../screens/recipe_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final APIService apiService = APIService();
  final ScrollController _scrollController = ScrollController();
  List<Recipe> _searchResults = [];
  List<Recipe> _randomRecipes = [];
  bool _isSearching = false;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _fetchRandomRecipes(); // Initial fetch of random recipes
    _scrollController.addListener(_onScroll); // Add listener for scroll events
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _fetchRandomRecipes() async {
    try {
      setState(() {
        _isLoadingMore = true; // Show loading indicator while fetching more data
      });

      final randomRecipes = await apiService.fetchRandomRecipes(); // Fetch random recipes
      setState(() {
        _randomRecipes.addAll(randomRecipes); // Append new recipes to existing list
        _isLoadingMore = false; // Hide loading indicator
      });
    } catch (e) {
      print('Error fetching random recipes: $e'); // Debugging: Log any errors
      setState(() {
        _isLoadingMore = false; // Hide loading indicator on error
      });
    }
  }

  void _onSearch(String query) async {
    setState(() {
      _isSearching = true;
    });

    try {
      final results = await apiService.searchRecipes(query);
      print('Search results: ${results.length} recipes found'); // Debugging: Check search results
      setState(() {
        _searchResults = results ?? [];
        _isSearching = false;
      });
    } catch (e) {
      print('Error during search: $e'); // Debugging: Log any search errors
      setState(() {
        _isSearching = false;
      });
    }
  }

  void _onRecipeTap(Recipe recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetailScreen(recipe: recipe),
      ),
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        !_isSearching) {
      // If near the bottom of the scroll, fetch more data
      _fetchRandomRecipes();
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0.0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover Recipes'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              CustomSearchBar(onSearch: _onSearch),
              Expanded(
                child: _isSearching
                    ? const Center(child: CircularProgressIndicator())
                    : _buildRecipeGridView(),
              ),
            ],
          ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: _scrollToTop,
              backgroundColor: Colors.grey, // Set button color to gray
              child: Icon(Icons.arrow_upward, color: Colors.white), // Icon for scrolling to top
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeGridView() {
    return GridView.builder(
      controller: _scrollController, // Attach ScrollController for infinite scroll
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of columns
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: _randomRecipes.length + 1, // Add an extra item for the loading indicator
      itemBuilder: (context, index) {
        if (index == _randomRecipes.length) {
          // Display loading indicator at the bottom
          return _isLoadingMore
              ? const Center(child: CircularProgressIndicator())
              : SizedBox.shrink();
        }
        final recipe = _randomRecipes[index];

        // Determine size type
        bool isLargeItem = index % 5 == 0; // Every 5th item is large

        return GestureDetector(
          onTap: () => _onRecipeTap(recipe),
          child: Container(
            height: isLargeItem ? 300.0 : 150.0, // Large or normal height
            width: double.infinity, // Full width
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              image: DecorationImage(
                image: NetworkImage(recipe.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12.0)),
                      color: Colors.black.withOpacity(0.6),
                    ),
                    child: Text(
                      recipe.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
