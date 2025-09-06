import 'package:flutter/material.dart' ;
import 'package:bottom_bar/bottom_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
   int _currentPage = 0;
  final _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("StudyMate",
        style: TextStyle(
          color: Colors.black,
        ),
        ),
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.search,)),
          IconButton(onPressed: (){}, icon: Icon(Icons.more_vert,))
        ],
      ),
      body: PageView(
        controller: _pageController,
        children: [
          Container(color: Colors.blue),
          Container(color: Colors.red),
          Container(color: Colors.greenAccent.shade700),
          Container(color: Colors.orange),
        ],
        onPageChanged: (index) {
          // Use a better state management solution
          // setState is used for simplicity
          setState(() => _currentPage = index);
        },
      ),
      bottomNavigationBar: BottomBar(
        selectedIndex: _currentPage,
        onTap: (int index) {
          _pageController.jumpToPage(index);
          setState(() => _currentPage = index);
        },
        items: <BottomBarItem>[
          BottomBarItem(
            icon: Icon(Icons.home,color: Colors.blue,),
            title: Text('Home'),
            activeColor: Colors.blue,
          ),
          BottomBarItem(
            icon: Icon(Icons.add,color: Colors.red,),
            title: Text('To-Do list'),
            activeColor: Colors.red,
          ),
          BottomBarItem(
            icon: Icon(Icons.camera,color: Colors.greenAccent.shade700,),
            title: Text('Camera'),
            activeColor: Colors.greenAccent.shade700,
          ),
          BottomBarItem(
            icon: Icon(Icons.settings,color: Colors.orange,),
            title: Text('Settings'),
            activeColor: Colors.orange,
          ),
        ],
      ),
    );
  }
}

