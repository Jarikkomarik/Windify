import 'package:flutter/material.dart';
import 'package:windify/view/HomePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          textSelectionTheme: TextSelectionThemeData(
            selectionColor: Colors.white12
          ),
          appBarTheme: AppBarTheme(
            brightness: Brightness.dark,
          ),
          colorScheme: ColorScheme.dark(),
        ),
        home: HomePage(),
    );
  }
}

