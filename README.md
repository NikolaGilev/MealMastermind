
# MealMastermind - Flutter Mobile App Documentation

## Project Overview

**MealMastermind** is a Flutter-based mobile application designed to assist users in meal planning by providing a database of recipes and meal options. 
The app interacts with a custom API that supplies recipe data and allows users to browse, select, and organize meals easily. The app is built with a modular architecture for ease of maintenance and scalability.

---

## Installation and Setup Instructions

### Prerequisites:
- **Flutter SDK** (ensure you have the latest version installed)
- **Dart SDK** (comes with the Flutter SDK)
- **Android Studio or VS Code** (with Flutter plugins)

### Step 1: Clone the Repository
Clone the project repository to your local machine.

```bash
git clone (https://github.com/NikolaGilev/MealMastermind.git)
```

### Step 2: Install Dependencies
Navigate to the project root directory and install the required dependencies by running:
```bash
flutter pub get
```

### Step 3: Run the App
Ensure you have an emulator or connected device running, then launch the app with:
```bash
flutter run
```

---

## Project Structure

#### 1. **`main.dart`**
This is the entry point of the Flutter app. It initializes the main application, configures global settings such as themes, and defines the routes for different screens.

#### 2. **`models/`**
Contains data models representing key objects in the app such as recipes and users.
   - **`recipe.dart`**: Defines the structure for a recipe object, including properties like title, ingredients, and instructions.
   - **`user.dart`**: Represents the user model, containing properties such as `name`, `email`, and authentication-related fields.

#### 3. **`screens/`**
Contains the different screens that make up the app's user interface.
   - **`home_screen.dart`**: The main screen where users can view the list of recipes. This screen fetches data from the API and displays it in a list format.
   - **`login_screen.dart`**: Handles user authentication via login.
   - **`recipe_detail_screen.dart`**: Displays detailed information for a selected recipe, including the recipe's ingredients and preparation steps.
   - **`search_screen.dart`**: Provides a search functionality for users to filter recipes based on various criteria.
   - **`map_screen.dart`**: Displays a map with a specific location marked, using `latitude` and `longitude` coordinates. This screen uses the `flutter_map` package to render the map.
   - **`map_picker_screen.dart`**: Allows users to pick a location on the map. Users can select a point, which is returned as latitude and longitude coordinates.

#### 4. **`services/`**
Contains the logic for making API calls and handling authentication.
   - **`api_service.dart`**: Manages interactions with the backend API. It contains methods like `fetchRecipes()` to get recipe data from the API.
   - **`auth_service.dart`**: Handles user authentication processes, including login, signup, and session management.
   - **`MapService.dart`**: Handles map-related functionalities, including launching external map applications. It provides methods like `openMap()` which allows the app to open an external map application with a specified location.

#### 5. **`utils/`**
Utility files that contain constants, themes, and other reusable functionality.
   - **`constants.dart`**: Contains constant values used throughout the app, such as API endpoints and other configuration settings.
   - **`theme.dart`**: Manages the app's visual theme, including colors, fonts, and styles.

#### 6. **`widgets/`**
Contains reusable UI components used across multiple screens.
   - **`rating_widget.dart`**: A widget used to display recipe ratings with stars.
   - **`recipe_card.dart`**: A custom widget that displays a recipe in a card layout for easy viewing on the main screen.
   - **`search_bar.dart`**: A reusable search bar widget, used in multiple screens to allow users to filter results.

---

## App Reference

### Main Components:

#### 1. `Recipe Model` (`models/recipe.dart`)
   - **Properties**:
     - `title`: String - The name of the recipe.
     - `ingredients`: List<String> - A list of ingredients required for the recipe.
     - `instructions`: String - Step-by-step instructions for preparing the recipe.
     - `rating`: double - The average user rating for the recipe.

#### 2. `User Model` (`models/user.dart`)
   - **Properties**:
     - `id`: String - The user's unique identifier.
     - `name`: String - The user's name.
     - `email`: String - The user's email address.
     - `isAuthenticated`: bool - Whether the user is logged in or not.

#### 3. `API Service` (`services/api_service.dart`)
   - **Methods**:
     - `fetchRecipes()`:
       - **Returns**: A list of `Recipe` objects fetched from the API.
       - **Description**: Makes a GET request to the API to retrieve the list of recipes.

     - `fetchRecipeById(int id)`:
       - **Parameters**: `id` (int) - The unique identifier for the recipe.
       - **Returns**: A single `Recipe` object with detailed information.
       - **Description**: Fetches a single recipe by its ID.

#### 4. `Auth Service` (`services/auth_service.dart`)
   - **Methods**:
     - `login(String email, String password)`:
       - **Parameters**: `email` (String), `password` (String)
       - **Returns**: A boolean indicating success or failure.
       - **Description**: Handles user login by sending credentials to the API and managing session tokens.

#### 5. `Map Service` (`services/MapService.dart`)
   - **Methods**:
     - `openMap(double longitude, double latitude)`:
       - **Parameters**: `longitude` (double), `latitude` (double) - The geographic coordinates to be opened in an external map application.
       - **Description**: Launches an external map application like Google Maps or Apple Maps with the specified coordinates, helping users locate a place on the map.

#### 6. `Map Screen` (`screens/map_screen.dart`)
   - **Properties**:
     - `latitude`: double - The latitude of the location to be displayed on the map.
     - `longitude`: double - The longitude of the location to be displayed on the map.
   - **Description**: This screen renders a map using the `flutter_map` package. It shows a specific location based on the provided coordinates.

#### 7. `Map Picker Screen` (`screens/map_picker_screen.dart`)
   - **Description**: This screen allows the user to interact with the map and select a location. The selected location is stored as latitude and longitude coordinates, which can be used in other parts of the app.

---

## User Manual

### Home Screen
1. **Browse Recipes**: Upon loading, the home screen will display a list of recipes fetched from the API. Each recipe is displayed in a card format showing the title and rating.
2. **Search**: Use the search bar at the top to filter recipes by name.
![image](https://github.com/user-attachments/assets/a3d4f415-a3f2-4ac0-91de-279addeae131)
![image](https://github.com/user-attachments/assets/dd2e7c8e-0c7f-49ed-9fe1-8b72902ead82)

### Recipe Detail Screen
1. **View Full Recipe**: This screen displays detailed information about the recipe selected from the home screen.
2. **Rate the Recipe**: Users can leave a rating for the recipe, which will update the overall rating displayed.
![image](https://github.com/user-attachments/assets/2e9209fb-66b8-4b9a-abac-a5d97b1ce65f)
![image](https://github.com/user-attachments/assets/4e32bf9b-61f8-4f7e-85bf-a5138a698059)

### Add New Recipe Screen
1. **Post A Recipe**: This screen has inputs for all the necessary fields to create a recepie.
![image](https://github.com/user-attachments/assets/abc39d30-ef25-4acd-bfd3-4a827fe1554b)
![image](https://github.com/user-attachments/assets/d34a3c97-ec28-4a33-bbed-fd28920e39b9)


### Login Screen
1. **Login**: Use your email and password to log in and access personalized features such as saving favorite recipes.

### Map Screen
1. **View Location**: This screen shows a map with a specific location marked. The location is based on latitude and longitude coordinates passed into the screen.
![image](https://github.com/user-attachments/assets/172547ff-a76b-4181-a184-33860ce2ffb7)

### Map Picker Screen
1. **Select a Location**: Users can interact with the map to select a location. The selected latitude and longitude are stored and can be used for other functionalities like saving or sending locations.

---


Nikola Gilev 196131
