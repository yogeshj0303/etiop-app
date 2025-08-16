import 'package:etiop_application/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'login_screen.dart'; // Import the LoginScreen
import 'guideline_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controller.forward();
    _checkLoginStatus();
  }

  // Check the login status after a short delay
  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2)); // Splash screen duration

    final prefs = await SharedPreferences.getInstance();
    final bool hasSeenGuideline = prefs.getBool('hasSeenGuideline') ?? false;
    final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (!hasSeenGuideline) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => GuidelineScreen(
            onComplete: () async {
              await prefs.setBool('hasSeenGuideline', true);
              final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => isLoggedIn ? const MainScreen() : const LoginScreen(),
                ),
              );
            },
          ),
        ),
      );
      return;
    }

    // Navigate to the appropriate screen based on login status
    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.welcome,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(4292815168),
                ),
              ),
              // const SizedBox(height: 20),
              // const CircularProgressIndicator(
              //   valueColor: AlwaysStoppedAnimation<Color>(Color(4292815168)),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
