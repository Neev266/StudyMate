import 'package:flutter/material.dart' ;
import 'package:bottom_bar/bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/Pages/Home_page.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
   int _currentPage = 0;
  final _pageController = PageController();
  
  Null get accountEmail => null;
  
  Null get accountName => null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
       leading: Builder(
          builder: (context) => IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        ),
        title: Text("StudyMate",
        style: TextStyle(
          color: Colors.black,
        ),
        ),
        
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.search,)),
          IconButton(onPressed: (){}, icon: Icon(Icons.more_vert,))
        ],
      ),
      drawer: Drawer(
      backgroundColor: Colors.white,
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                gradient:LinearGradient(
                  colors: [Colors.white],
                  )
                  ),
              accountName:accountName,
              accountEmail: accountEmail),
            ListTile(
              title: Text("Item 1",
                style: TextStyle(
                  color: Colors.black,
                ),
                ),
              onTap: (){},
            ),
            ListTile(
              leading: const Icon(Icons.logout,
              color: Colors.red,
              ),
              title: Text("Log out",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                ),
                ),
              onTap: ()async{
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/welcome');
              },
            ),
          ],
        ),
      ),
      body: PageView(
        controller: _pageController,
        children: [
          Home_Page(),
          Container(color: Colors.red),
          Container(color: Colors.greenAccent.shade700),
          Container(color: Colors.orange),
        ],
        onPageChanged: (index) {
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

