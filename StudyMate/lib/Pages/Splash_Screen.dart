
import 'dart:async'; 
import 'package:flutter/material.dart';
import 'package:flutter_app/Pages/welcome.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState(){
    super.initState();
    Future.delayed(Duration(seconds: 2),(){

      Navigator.pushReplacement(
        
        context, MaterialPageRoute(
        builder:  (context)=>WelcomePage(),
        ),
        
        );

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:Center(
        child: Image.asset(
          'assets/images/SplashScreen.png',
          
          width: 300,
          height: 300,
        ),
      )
    );
  }
}