import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart' ;
import 'package:flutter_app/Pages/Splash_Screen.dart';
import 'package:flutter_app/Pages/login.dart';
import 'package:flutter_app/Pages/welcome.dart';
import 'Pages/signup.dart';
import 'Pages/home.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),      // light theme
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => Home(),
        '/signin': (context) => Signup(),
        '/login': (context) => Login(),
        '/welcome':(context) => WelcomePage(),
      }
    );
  }
}
