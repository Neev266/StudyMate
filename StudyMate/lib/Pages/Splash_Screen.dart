
import 'dart:async'; 
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


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
       FirebaseAuth.instance.authStateChanges().first.then((user){
        if(user==null){
          Navigator.pushReplacementNamed(context, '/welcome');
        } else{
          Navigator.pushReplacementNamed(context, '/home');
        }
      });

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