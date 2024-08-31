
const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const fs = require('fs');
const Fuse = require('fuse.js');
const dataGen = require('./random_data.js');

const app = express();
const PORT = process.env.PORT || 5000;

app.use(cors());
app.use(bodyParser.json());

var recipes = [];
var fuse;
fs.readFile('recipes.json', 'utf8', function (err, data) {
  if (err) throw err;
  recipes = JSON.parse(data);
  fuse = new Fuse(recipes, {keys: ['title'], threshold: 0.3});
});

// Routes
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
    const recipes = dataGen.generateRandomRecipes(10); 
    res.json(recipes);
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
