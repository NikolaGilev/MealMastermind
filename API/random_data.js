const { faker } = require("@faker-js/faker");

const foodNames = [
  "Pizza",
  "Burger",
  "Pasta",
  "Salad",
  "Sushi",
  "Steak",
  "Tacos",
  "Sandwich",
  "Soup",
  "Ice Cream",
  "Chocolate Cake",
  "Apple Pie",
  "Spaghetti",
  "Ramen",
  "Pancakes",
  "Lasagna",
  "Curry",
  "Dumplings",
];

// Generate random recipes using faker
function generateRandomRecipes(count = 10) {
  const recipes = [];
  for (let i = 0; i < count; i++) {
    const id = faker.number.int({ min: 26, max: 100 });
    const foodName = faker.helpers.arrayElement(foodNames);
    const title = `${faker.commerce.productAdjective()} ${foodName}`;
    const imageUrl = faker.image.urlLoremFlickr({
      category: "food",
      query: foodName.split(" ").join("+"),
    });

    const ingredients = Array.from(
      { length: faker.number.int({ min: 2, max: 6 }) },
      () => ({
        name: faker.commerce.productMaterial(),
        grams: faker.number.int({ min: 50, max: 500 }),
      })
    );

    const instructions = Array.from(
      { length: faker.number.int({ min: 3, max: 6 }) },
      () => faker.lorem.sentence()
    );

    const nutritionalInfo = {
      calories: faker.number.int({ min: 200, max: 700 }),
      fat: faker.number.int({ min: 5, max: 30 }),
      carbs: faker.number.int({ min: 20, max: 80 }),
      protein: faker.number.int({ min: 10, max: 40 }),
    };

    const rating = faker.number.float({ min: 3, max: 5, multipleOf: 0.1 });
    const author = `${faker.person.firstName()} ${faker.person.lastName()}`;
    const description = faker.lorem.sentence();
    const datePosted = `${faker.date.past().toISOString().split("T")[0]}`;
    const preparationTime = faker.number.int({ min: 10, max: 60 });
    const likes = faker.number.int({ min: 0, max: 100 });
    const comments = [];

    const latitude = `${faker.location.latitude({
      max: 42.08,
      min: 41.94,
      precision: 4,
    })}`;
    const longitude = `${faker.location.longitude({
      max: 21.53,
      min: 21.36,
      precision: 4,
    })}`;

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
      comments,
      latitude,
      longitude,
    });
  }

  return recipes;
}

module.exports = { generateRandomRecipes };
