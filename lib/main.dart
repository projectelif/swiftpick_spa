import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:swiftpick_spa/auth/home_page.dart';
import 'package:swiftpick_spa/auth/login_page.dart';
import 'firebase_options.dart'; 
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title:'SwiftPick SPA',
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomePage(); // Giriş yapılmış
          } else {
            return LoginPage(); // Giriş yapılmamış
          }
        },
      ),
    );
  }
}