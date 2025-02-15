import 'package:etiop_application/screens/splash_screen.dart';
import 'package:etiop_application/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:etiop_application/screens/subcategory_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: MaterialTheme(
        GoogleFonts.getTextTheme(
          'Poppins',
        ),
      ).light(),
      home: const SplashScreen(),
      routes: {
        '/subcategory': (context) => SubcategoryScreen(
          category: ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>
        ),
      },
    );
  }
}
