import 'package:flutter/material.dart';
import 'package:meal_mastermind/screens/home_screen.dart';
import 'package:meal_mastermind/screens/main_screen.dart';  // Correct import path
import 'package:meal_mastermind/utils/theme.dart';
import 'package:meal_mastermind/services/auth_service.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MealMastermindApp());
}

class MealMastermindApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        title: 'Meal Mastermind',
        theme: appTheme,
        home: MainScreen(),
      ),
    );
  }
}
