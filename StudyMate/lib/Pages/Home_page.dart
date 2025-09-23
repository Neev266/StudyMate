import 'package:flutter/material.dart' ;

class Home_Page extends StatefulWidget {
  const Home_Page({super.key});

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Text("Notes",
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
        ),
      ),
    );
  }
}