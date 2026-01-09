import 'package:flutter/material.dart';
import 'package:bottom_bar/bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/features/Chatbot/bloc/chatbot_bloc.dart';
import 'package:flutter_app/features/Chatbot/bloc/chatbot_event.dart';
import 'package:flutter_app/features/Chatbot/data/chatbot_service.dart';
import 'package:flutter_app/features/Game/bloc/game_bloc.dart';
import 'package:flutter_app/features/Game/data/game_service.dart';
import 'package:flutter_app/features/Game/view/game_view.dart';
import 'package:flutter_app/core/api/api_game.dart';
import 'package:flutter_app/core/search/app_search.dart';
import 'package:flutter_app/features/Notes/bloc/notes_bloc.dart';
import 'package:flutter_app/features/Notes/bloc/notes_event.dart';
import 'package:flutter_app/features/Notes/view/notes_view.dart';
import 'package:flutter_app/features/to-do/bloc/todo_bloc.dart';
import 'package:flutter_app/features/to-do/bloc/todo_event.dart';
import 'package:flutter_app/features/to-do/view/todo_view.dart';
import 'package:flutter_app/features/Notes/notes_list.dart';
import 'package:flutter_app/features/Chatbot/view/chatbot_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


enum HomeTab { todo, notes, chatbot }

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class Responsive {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 700;

  static bool isWeb(BuildContext context) =>
      MediaQuery.of(context).size.width >= 700;
}



class _HomeState extends State<Home> {
  double _boredBtnX = 20;
  double _boredBtnY = 500;
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentPage = 0;
  final _pageController = PageController();


    HomeTab get currentTab {
    switch (_currentPage) {
      case 0:
        return HomeTab.todo;
      case 1:
        return HomeTab.notes;
      default:
        return HomeTab.chatbot;
    }
  }

  List<PopupMenuEntry<String>> _todoMenu() {
    return const [
      PopupMenuItem(value: 'newest', child: Text('Newest first')),
      PopupMenuItem(value: 'oldest', child: Text('Oldest first')),
      PopupMenuItem(value: 'alpha', child: Text('A → Z')),
      PopupMenuDivider(),
      PopupMenuItem(value: 'completed', child: Text('Completed')),
      PopupMenuItem(value: 'pending', child: Text('Pending')),
    ];
  }

  List<PopupMenuEntry<String>> _notesMenu() {
    return const [
      PopupMenuItem(value: 'newest', child: Text('Newest first')),
      PopupMenuItem(value: 'oldest', child: Text('Oldest first')),
      PopupMenuItem(value: 'alpha', child: Text('A → Z')),
      PopupMenuDivider(),
      PopupMenuItem(value: 'text', child: Text('Text only')),
      PopupMenuItem(value: 'image', child: Text('Has image')),
      PopupMenuItem(value: 'pdf', child: Text('Has PDF')),
    ];
  }

  List<PopupMenuEntry<String>> _chatbotMenu() {
  return const [
    PopupMenuItem(value: 'new', child: Text('🆕 New Chat')),
    PopupMenuItem(value: 'history', child: Text('📜 Chat History')),
  ];
}



  void _handleMenuAction(BuildContext context, String value) {
    // print("🟡 MENU CLICKED: value=$value, currentTab=$currentTab");
    if (currentTab == HomeTab.notes) {
      switch (value) {
        case 'newest':
          context.read<NotesBloc>().add(
            NotesSortChanged(NotesSortType.newestFirst),
          );
          break;
        case 'oldest':
          context.read<NotesBloc>().add(
            NotesSortChanged(NotesSortType.oldestFirst),
          );
          break;
        case 'alpha':
          context.read<NotesBloc>().add(
            NotesSortChanged(NotesSortType.alphabetical),
          );
          break;
        case 'text':
          context.read<NotesBloc>().add(
            NotesFilterChanged(NotesFilterType.textOnly),
          );
          break;
        case 'image':
          context.read<NotesBloc>().add(
            NotesFilterChanged(NotesFilterType.hasImage),
          );
          break;
        case 'pdf':
          context.read<NotesBloc>().add(
            NotesFilterChanged(NotesFilterType.hasPdf),
          );
          break;
      }
    }

    if (currentTab == HomeTab.todo) {
    switch (value) {
      case 'newest':
        context.read<TodoBloc>().add(
          TodoSortChanged(TodoSortType.newestFirst),
        );
        break;
      case 'oldest':
        context.read<TodoBloc>().add(
          TodoSortChanged(TodoSortType.oldestFirst),
        );
        break;
      case 'alpha':
        context.read<TodoBloc>().add(
          TodoSortChanged(TodoSortType.alphabetical),
        );
        break;
      case 'completed':
        context.read<TodoBloc>().add(
          TodoFilterChanged(TodoFilterType.completed),
        );
        break;
      case 'pending':
        context.read<TodoBloc>().add(
          TodoFilterChanged(TodoFilterType.pending),
        );
        break;
    }
  }

if (currentTab == HomeTab.chatbot) {
  // print("🟢 CHATBOT TAB ACTIVE");
  switch (value) {
    case 'new':
    print("🧪 HOME sees ChatbotBloc = ${context.read<ChatbotBloc>().hashCode}");
      context.read<ChatbotBloc>().add(
        StartNewChat(userId!),
      );
      break;

    case 'history':
    // print("🟢 CHAT HISTORY SELECTED");
      _showChatHistory(context);
      break;
  }
}
}


  final currentUser = FirebaseAuth.instance.currentUser;
  String? get userId => currentUser?.uid;

  @override
  @override
Widget build(BuildContext context) {
  final bool isWeb = MediaQuery.of(context).size.width >= 900;

  return Scaffold(
    key: _scaffoldKey,
    backgroundColor: Colors.white,
  
    appBar: AppBar(
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.black),
      leading: isWeb
          ? null
          : Builder(
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
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            if (currentTab == HomeTab.chatbot) return;
            showSearch(
              context: context,
              delegate: AppSearchDelegate(currentTab),
            );
          },
        ),
        Builder(
          builder:(scaffoldContext){
          return PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              _handleMenuAction(context, value);
            },
            itemBuilder: (context) {
              if (currentTab == HomeTab.todo) return _todoMenu();
              if (currentTab == HomeTab.notes) return _notesMenu();
              return _chatbotMenu();
            },
          );
          }
        ),
      ],
    ),
  
    // Drawer only on mobile
    drawer: isWeb ? null : Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPictureSize: const Size.square(80),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.grey.shade200],
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.grey.shade400,
              child: const Icon(Icons.person, size: 40, color: Colors.white),
            ),
            accountName: Text(
              currentUser?.displayName ?? "User",
              style: const TextStyle(color: Colors.red),
            ),
            accountEmail: Text(
              currentUser?.email ?? "No email",
              style: const TextStyle(color: Colors.black),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.add, color: Colors.red),
            title: const Text("To-Do",
                style: TextStyle(color: Colors.red, fontSize: 18)),
            onTap: () {
              setState(() => _currentPage = 0);
              _pageController.jumpToPage(0);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.notes, color: Colors.red),
            title: const Text("Notes",
                style: TextStyle(color: Colors.red, fontSize: 18)),
            onTap: () {
              setState(() => _currentPage = 1);
              _pageController.jumpToPage(1);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.chat_bubble_outline, color: Colors.red),
            title: const Text("ChatBot",
                style: TextStyle(color: Colors.red, fontSize: 18)),
            onTap: () {
              setState(() => _currentPage = 2);
              _pageController.jumpToPage(2);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Log out",
                style: TextStyle(color: Colors.red, fontSize: 18)),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/welcome');
            },
          ),
        ],
      ),
    ),
  
    body: Row(
      children: [
        // Fixed sidebar only on web
        if (isWeb)
          Container(
            width: 260,
            color: Colors.white,
            child: Column(
              children: [
                const SizedBox(height: 20),
                ListTile(
                  leading: Icon(Icons.add,
                      color: _currentPage == 0
                          ? Colors.blue
                          : Colors.black),
                  title: const Text("To-Do",style: TextStyle(color: Colors.black),),
                  onTap: () {
                    _pageController.jumpToPage(0);
                    setState(() => _currentPage = 0);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.notes,
                      color: _currentPage == 1
                          ? Colors.blue
                          : Colors.black),
                  title: const Text("Notes",style: TextStyle(color: Colors.black),),
                  onTap: () {
                    _pageController.jumpToPage(1);
                    setState(() => _currentPage = 1);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.chat_bubble_outline,
                      color: _currentPage == 2
                          ? Colors.blue
                          : Colors.black),
                  title: const Text("ChatBot",style: TextStyle(color: Colors.black),),
                  onTap: () {
                    _pageController.jumpToPage(2);
                    setState(() => _currentPage = 2);
                  },
                ),
              ],
            ),
          ),
  
        Expanded(
          child: Stack(
            children: [
              PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                children: [
                  const ToDoList(),
                  const NotesView(),
                  ChatbotPage(userId: userId),
                ],
              ),
  
              Positioned(
                left: _boredBtnX,
                top: _boredBtnY,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      _boredBtnX += details.delta.dx;
                      _boredBtnY += details.delta.dy;
                    });
                  },
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (_) =>
                              BoredBloc(BoredRepository(ApiClient())),
                          child: const BoredView(),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.casino,
                        color: Colors.white, size: 28),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  
    // Bottom bar only on mobile
    bottomNavigationBar: isWeb
        ? null
        : BottomBar(
            selectedIndex: _currentPage,
            onTap: (index) {
              _pageController.jumpToPage(index);
              setState(() => _currentPage = index);
            },
            items: [
              BottomBarItem(
                icon: const Icon(Icons.add, color: Colors.blue),
                title: const Text('To-Do',
                style: TextStyle(color: Colors.black)
                ),
                activeColor: Colors.blue,
              ),
              BottomBarItem(
                icon: const Icon(Icons.note, color: Colors.red),
                title: const Text('Notes',
                style: TextStyle(color: Colors.black)
                ),
                activeColor: Colors.red,
              ),
              BottomBarItem(
                icon: const Icon(Icons.chat_bubble_outline,
                    color: Colors.orange),
                title: const Text('Chatbot',
                style: TextStyle(color: Colors.black)
                ),
                activeColor: Colors.orange,
              ),
            ],
          ),
  );
}


  void _showChatHistory(BuildContext _) async {
  print("🔵 _showChatHistory CALLED");

  // ✅ Use Scaffold context (NOT AppBar / PopupMenu context)
  final scaffoldContext = _scaffoldKey.currentContext!;
  final chatbotBloc =
      BlocProvider.of<ChatbotBloc>(scaffoldContext, listen: false);

  final chats =
      await ChatbotService().getChatHistory(userId!);

  if (!mounted) return;

  showModalBottomSheet(
    context: scaffoldContext,
    builder: (sheetContext) {
      return ListView(
        children: chats.map((chat) {
          return ListTile(
            title: Text(
              chat["lastMessage"]!.isEmpty
                  ? "Untitled Chat"
                  : chat["lastMessage"]!,
            ),
            subtitle: const Text("Tap to open • Long press to delete"),

            onTap: () {
              Navigator.pop(sheetContext);
              chatbotBloc.add(
                LoadOldChat(
                  userId: userId!,
                  chatId: chat["id"],
                ),
              );
            },

            onLongPress: () async {
              await ChatbotService().deleteChat(
                userId: userId!,
                chatId: chat["id"],
              );
              Navigator.pop(sheetContext);
              _showChatHistory(scaffoldContext);
            },
          );
        }).toList(),
      );
    },
  );
}

}



