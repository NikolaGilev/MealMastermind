const { faker } = require('@faker-js/faker');

const foodNames = [
  'Pizza', 'Burger', 'Pasta', 'Salad', 'Sushi', 'Steak', 'Tacos', 'Sandwich', 'Soup', 'Ice Cream',
  'Chocolate Cake', 'Apple Pie', 'Spaghetti', 'Ramen', 'Pancakes', 'Lasagna', 'Curry', 'Dumplings',
];

function generateRandomRecipes(count = 10) {
  const recipes = [];

  for (let i = 0; i < count; i++) {
    const id = faker.number.int({ min: 26, max: 100 });
    const foodName = faker.helpers.arrayElement(foodNames); 
    const title = `${faker.commerce.productAdjective()} ${foodName}`;
    const imageUrl = faker.image.urlLoremFlickr({ category: 'food', query: foodName.split(' ').join('+') });
    const ingredients = `${faker.number.int({ min: 100, max: 500 })}g ${faker.commerce.productMaterial()}, ${faker.number.int({ min: 1, max: 10 })} ${faker.commerce.productAdjective()} ${foodName}`;
    const instructions = faker.lorem.paragraphs(3);
    const nutritionalInfo = `Calories: ${faker.number.int({ min: 200, max: 700 })}, Fat: ${faker.number.int({ min: 5, max: 30 })}g, Carbs: ${faker.number.int({ min: 20, max: 80 })}g, Protein: ${faker.number.int({ min: 10, max: 40 })}g`;
    const rating = faker.number.float({ min: 3, max: 5, multipleOf: 0.1 });
    const author = `${faker.person.firstName()} ${faker.person.lastName()}`;
    const description = faker.lorem.sentence();
    const datePosted = `${faker.date.past().toISOString().split('T')[0]}`;
    const preparationTime = `${faker.number.int({ min: 10, max: 60 })} minutes`;
    const likes = `${faker.number.int({ min: 0, max: 100 })}`;

    recipes.push({
      id,
      title,
      imageUrl,
      ingredients,
      instructions,
      nutritionalInfo,
      rating,
      author,
      description,
      datePosted,
      preparationTime,
      likes,
    });
  }

  return recipes;
}

module.exports = { generateRandomRecipes };
