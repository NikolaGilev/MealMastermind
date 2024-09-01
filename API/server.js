const randomData = require('./random_data.js');
const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const fs = require('fs');
const Fuse = require('fuse.js');
const multer = require('multer');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 5000;

app.use(cors());
app.use(bodyParser.json());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

let recipes = [];
let fuse;

fs.readFile('recipes.json', 'utf8', function (err, data) {
  if (err) throw err;
  recipes = JSON.parse(data);
  fuse = new Fuse(recipes, { keys: ['title'], threshold: 0.3 });
});

// Set up storage for image uploads
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/'); // Folder to store images
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + path.extname(file.originalname));
  }
});

const upload = multer({ storage: storage });


// API Routes
app.post('/api/recipes/:id/likes', (req, res) => {
  const recipe = recipes.find(r => r.id === parseInt(req.params.id));
  if (recipe) {
    recipe.likes += req.body.increment;
    res.status(200).json({ message: 'Likes updated successfully!', likes: recipe.likes });
  } else {
    res.status(404).send('Recipe not found');
  }
});

app.post('/api/recipes/:id/comments', (req, res) => {
  const recipeId = parseInt(req.params.id);
  const recipe = recipes.find(r => r.id === recipeId);

  if (!recipe) {
    return res.status(404).json({ message: 'Recipe not found' });
  }

  recipe.comments = recipe.comments || [];

  const newComment = {
    id: recipe.comments.length + 1, 
    author: req.body.author,
    content: req.body.content,
    datePosted: new Date().toISOString(),
  };

  recipe.comments.push(newComment);

  res.status(200).json({ message: 'Comment added successfully', comment: newComment });
});

app.get('/api/recipes/:id', (req, res) => {
  const recipe = recipes.find(r => r.id === parseInt(req.params.id));
  if (recipe) {
    recipe.comments = recipe.comments || [];
    res.json(recipe);
  } else {
    res.status(404).send('Recipe not found');
  }
});

app.post('/api/recipes', upload.single('image'), (req, res) => {
  const newRecipe = {
    id: recipes.length + 1,
    title: req.body.title,
    author: req.body.author,
    description: req.body.description,
    datePosted: req.body.datePosted,
    preparationTime: req.body.preparationTime,
    likes: req.body.likes,
    ingredients: JSON.parse(req.body.ingredients),  // Parse ingredients JSON
    instructions: JSON.parse(req.body.instructions),  // Parse instructions JSON
    nutritionalInfo: JSON.parse(req.body.nutritionalInfo),  // Parse nutritional info JSON
    rating: parseFloat(req.body.rating),
    imageUrl: req.file ? `/uploads/${req.file.filename}` : '',
  };

  recipes.push(newRecipe);

  // Save recipes to file
  fs.writeFile('recipes.json', JSON.stringify(recipes), (err) => {
    if (err) {
      console.error('Error saving recipe:', err);
      return res.status(500).json({ message: 'Failed to save recipe.' });
    }
    res.status(200).json({ message: 'Recipe posted successfully!', recipe: newRecipe });
  });
});

app.get('/api/recipes/search', (req, res) => {
  const searchQuery = req.query.q;
  if (!searchQuery) {
    return res.status(400).send({ message: 'Search query is required' });
  }
  const results = fuse.search(searchQuery);
  const matchedRecipes = results.map(result => result.item);
  res.send(matchedRecipes);
});

app.get('/api/recipes', (req, res) => {
  res.json(recipes);
});

app.get('/api/random-recipes', (req, res) => {
  const randomRecipes = randomData.generateRandomRecipes(10);
  res.json(randomRecipes);
});

app.get('/api/recipes/:id', (req, res) => {
  const recipe = recipes.find(r => r.id === parseInt(req.params.id));
  if (recipe) {
    res.json(recipe);
  } else {
    res.status(404).send('Recipe not found');
  }
});

// Start Server
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
