import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.blue,
  ).copyWith(
    secondary: Colors.orange,
  ),
  textTheme: const TextTheme(
    headline6: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
    bodyText2: TextStyle(fontSize: 14.0, color: Colors.black),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20.0,
    ),
  ),
  cardTheme: const CardTheme(
    margin: EdgeInsets.all(10),
    elevation: 5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
  ),
);
