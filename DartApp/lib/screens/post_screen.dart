import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'dart:io';
import '../models/recipe.dart';
import '../services/api_service.dart';
import 'map_picker_screen.dart';

class PostScreen extends StatefulWidget {
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  final _formKey = GlobalKey<FormState>();
  final APIService apiService = APIService();
  bool _isPosting = false;
  LatLng? _selectedLocation; // To store selected location

  // function to open the map picker
  Future<void> _pickLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapPickerScreen(),
      ),
    );
    if (result != null) {
      setState(() {
        _selectedLocation = result;
      });
    }
  }

  // Recipe details controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<Map<String, TextEditingController>> _ingredients = [
    {'name': TextEditingController(), 'grams': TextEditingController()},
  ];
  final List<TextEditingController> _instructions = [TextEditingController()];
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _fatsController = TextEditingController();
  final TextEditingController _carbsController = TextEditingController();
  final TextEditingController _preparationTimeController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _fatsController.dispose();
    _carbsController.dispose();
    _preparationTimeController.dispose();
    _ingredients.forEach((ingredient) {
      ingredient['name']!.dispose();
      ingredient['grams']!.dispose();
    });
    _instructions.forEach((controller) => controller.dispose());
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _addIngredient() {
    setState(() {
      _ingredients.add({'name': TextEditingController(), 'grams': TextEditingController()});
    });
  }

  void _addInstruction() {
    setState(() {
      _instructions.add(TextEditingController());
    });
  }
  void _submitRecipe() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isPosting = true;
      });

      // Create the Recipe object
      Recipe newRecipe = Recipe(
        id: 0, // Assuming the server auto-generates the ID
        title: _titleController.text,
        author: 'Current User', // Replace with current user's name or ID
        description: _descriptionController.text,
        datePosted: DateTime.now().toString(),
        preparationTime: int.parse(_preparationTimeController.text),
        likes: 0,
        imageUrl: '', // Image URL will be filled by the server
        ingredients: _ingredients.map((ingredient) => {
          'name': ingredient['name']!.text,
          'grams': int.parse(ingredient['grams']!.text)
        }).toList(),
        instructions: _instructions.map((controller) => controller.text).toList(),
        nutritionalInfo: {
          'calories': int.parse(_caloriesController.text),
          'protein': int.parse(_proteinController.text),
          'fat': int.parse(_fatsController.text),
          'carbs': int.parse(_carbsController.text),
        },
        rating: 0.0,
        latitude: _selectedLocation != null ? _selectedLocation!.latitude.toString() : "",
        longitude: _selectedLocation != null ? _selectedLocation!.longitude.toString() : "",
      );

      // Call API to save the recipe
      bool success = await apiService.postRecipe(newRecipe, _imageFile);

      // Check if the widget is still mounted before calling setState()
      if (!mounted) return;

      setState(() {
        _isPosting = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Recipe posted successfully!')),
        );
        // Show success animation and then navigate back to home
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to post recipe.')),
        );
      }
    }
  }


  Widget _buildPostingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: _isPosting
            ? CircularProgressIndicator()
            : Icon(Icons.check_circle, color: Colors.green, size: 60.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post a Recipe'),
      ),
      body: Stack(
        children: [
          _isPosting ? _buildPostingOverlay() : Container(),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: _imageFile == null
                          ? Container(
                        width: 200,
                        height: 200,
                        color: Colors.grey[200],
                        child: Icon(Icons.camera_alt, color: Colors.grey[800]),
                      )
                          : Image.file(
                        _imageFile!,
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: 'Title'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Ingredients',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  ..._ingredients.map((ingredient) {
                    int index = _ingredients.indexOf(ingredient);
                    return Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: ingredient['name'],
                            decoration: InputDecoration(labelText: 'Ingredient ${index + 1}'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an ingredient';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: TextFormField(
                            controller: ingredient['grams'],
                            decoration: InputDecoration(labelText: 'Grams'),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter grams';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                  TextButton(
                    onPressed: _addIngredient,
                    child: Text('Add Ingredient'),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Instructions',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  ..._instructions.map((controller) {
                    int index = _instructions.indexOf(controller);
                    return TextFormField(
                      controller: controller,
                      decoration: InputDecoration(labelText: 'Step ${index + 1}'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an instruction step';
                        }
                        return null;
                      },
                    );
                  }).toList(),
                  TextButton(
                    onPressed: _addInstruction,
                    child: Text('Add Instruction'),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _caloriesController,
                          decoration: InputDecoration(labelText: 'Calories'),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter calories';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: TextFormField(
                          controller: _proteinController,
                          decoration: InputDecoration(labelText: 'Protein'),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter protein amount';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: TextFormField(
                          controller: _fatsController,
                          decoration: InputDecoration(labelText: 'Fats'),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter fat amount';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: TextFormField(
                          controller: _carbsController,
                          decoration: InputDecoration(labelText: 'Carbs'),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter carb amount';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _preparationTimeController,
                    decoration: InputDecoration(labelText: 'Preparation Time (minutes)'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter preparation time';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: _pickLocation,
                    child: Text(_selectedLocation == null
                        ? 'Select Location'
                        : 'Location Selected: (${_selectedLocation!.latitude}, ${_selectedLocation!.longitude})'),
                  ),
                  SizedBox(height: 20.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: _submitRecipe,
                      child: Text('Post Recipe'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
