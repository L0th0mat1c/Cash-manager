import 'package:flutter/material.dart';

class Constants {
  static String appName = "Foody Bite";

  //Colors for theme
  static Color lightPrimary = const Color(0xfffcfcff);
  static Color darkPrimary = Colors.black;
  static Color lightAccent = const Color(0xff5563ff);
  static Color darkAccent = const Color(0xff5563ff);
  static Color lightBG = const Color(0xfffcfcff);
  static Color darkBG = Colors.black;
  static Color ratingBG = Colors.yellow[600];

  static ThemeData lightTheme = ThemeData(
    backgroundColor: lightBG,
    primaryColor: lightPrimary,
    scaffoldBackgroundColor: lightBG,
    appBarTheme: const AppBarTheme(),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    backgroundColor: darkBG,
    primaryColor: darkPrimary,
    scaffoldBackgroundColor: darkBG,

    appBarTheme: const AppBarTheme(),
  );
  static  List productsList = [
    {
      'title': 'Tomates rondes',
      'src': 'products/tomate_ronde.jpg',
      'price': '3.75',
      'measure': "Kg",
      'origin': "Espagne"
    },
    {
      'title': 'Ail',
      'src': 'products/ail.jpg',
      'price': '4.85',
      'measure': "Kg",
      'origin': "Espagne"
    },
    {
      'title': 'Bananes',
      'src': 'products/banane.jpg',
      'price': '2.9',
      'measure': "Kg",
      'origin': "Côte d'Ivoire"
    },
    {
      'title': 'Oignons',
      'src': 'products/oignon.jpg',
      'price': '2.3',
      'measure': "Kg",
      'origin': "France"
    },
    {
      'title': 'Poivrons',
      'src': 'products/poivron.jpg',
      'price': '3.6',
      'measure': "Kg",
      'origin': "France"
    },
    {
      'title': 'Comcombres',
      'src': 'products/comcombre.jpg',
      'price': '1.5',
      'measure': "Kg",
      'origin': "France"
    },
    {
      'title': 'Cerises',
      'src': 'products/cerise.jpg',
      'price': '6.7',
      'measure': "Kg",
      'origin': "France"
    },
    {
      'title': 'Pommes',
      'src': 'products/pomme.jpg',
      'price': '2.85',
      'measure': "Kg",
      'origin': "France"
    },
      {
      'title': 'Fraises',
      'src': 'products/fraise.jpg',
      'price': '7.6',
      'measure': "Kg",
      'origin': "France"
    },
      {
      'title': 'Aubergines',
      'src': 'products/aubergine.jpg',
      'price': '2.1',
      'measure': "Kg",
      'origin': "France"
    },
  ];
}