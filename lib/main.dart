import 'package:etiop_application/screens/splash_screen.dart';
import 'package:etiop_application/services/notification_services.dart';
import 'package:etiop_application/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:etiop_application/screens/subcategory_screen.dart';
import 'package:etiop_application/services/payment_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Add this import

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationService().initialize();
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
            category: ModalRoute.of(context)!.settings.arguments
                as Map<String, dynamic>),
      },
      navigatorKey: PaymentService.navigatorKey,
    );
  }
}
