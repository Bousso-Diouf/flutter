import 'package:flutter/material.dart';
import 'package:meteoapp/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Initialiser avec un mode clair
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mon Application',
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData.light().copyWith(
        // Personnalisation du thème clair si nécessaire
        appBarTheme: AppBarTheme(color: Colors.blue),
      ),
      darkTheme: ThemeData.dark().copyWith(
        // Personnalisation du thème sombre si nécessaire
        appBarTheme: AppBarTheme(color: Colors.black),
      ),
      home: HomeScreen(
        toggleTheme: _toggleTheme,
      ),
    );
  }

  // Méthode pour alterner entre le mode clair et sombre
  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }
}
