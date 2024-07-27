import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/screen/menu.dart';
import 'package:myapp/screen/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          color: Colors.white, // Couleur de l'AppBar
          iconTheme: IconThemeData(
              color: Colors.black), // Couleur des icônes de l'AppBar
        ),
        scaffoldBackgroundColor:
            Colors.white, // Couleur de fond du Scaffold (corps)
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
// Suggested code may be subject to a license. Learn more: ~LicenseLog:1682513264.
      home: FutureBuilder<String?>(
        future: _getStoredUid(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasData && snapshot.data != null) {
            return Menu(); // Rediriger vers la page principale si l'UID est stocké
          } else {
            return Onboarding(); // Rediriger vers la page de connexion si l'UID n'est pas trouvé
          }
        },
      ),
    );
  }

  Future<String?> _getStoredUid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_uid');
  }
}
