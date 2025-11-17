import 'package:flutter/material.dart';
import 'package:bottom_bar/bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/Chatbot/chatbot1.dart';
import 'package:flutter_app/to-do/ToDoList.dart';
import 'package:flutter_app/Notes/notes_list.dart';
import 'package:flutter_app/Chatbot/chatbot.dart'; // ✅ Updated import

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentPage = 0;
  final _pageController = PageController();

  final currentUser = FirebaseAuth.instance.currentUser;
  String? get userId => currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          "StudyMate",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.grey.shade200],
                ),
              ),
              accountName: Text(currentUser?.displayName ?? "User"),
              accountEmail: Text(currentUser?.email ?? "No email"),
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                "Log out",
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
              onTap: () async {
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
          const ToDoList(),
          const NotesList(),
          ChatbotPage(userId: userId ?? "guest"), // ✅ safe fallback
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
            icon: const Icon(Icons.add, color: Colors.blue),
            title: const Text('To-Do'),
            activeColor: Colors.blue,
          ),
          BottomBarItem(
            icon: const Icon(Icons.note, color: Colors.red),
            title: const Text('Notes'),
            activeColor: Colors.red,
          ),
          BottomBarItem(
            icon: const Icon(Icons.chat_bubble_outline, color: Colors.orange),
            title: const Text('Chatbot'),
            activeColor: Colors.orange,
          ),
        ],
      ),
    );
  }
}
