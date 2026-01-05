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

class _HomeState extends State<Home> {
  double _boredBtnX = 20;
  double _boredBtnY = 500;

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
  switch (value) {
    case 'new':
      context.read<ChatbotBloc>().add(
        StartNewChat(userId!),
      );
      break;

    case 'history':
      _showChatHistory(context);
      break;
  }
}
}


  final currentUser = FirebaseAuth.instance.currentUser;
  String? get userId => currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatbotBloc(ChatbotService())
      ..add(StartNewChat(userId!)),
      child: Scaffold(
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
      
            PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  _handleMenuAction(context, value);
                },
                itemBuilder: (context) {
                  if (currentTab == HomeTab.todo) {
                    return _todoMenu();
                  } else if (currentTab == HomeTab.notes) {
                    return _notesMenu();
                  } else if(currentTab==HomeTab.chatbot){
                    return _chatbotMenu();
                  }
                  return[];
                },
              ),
      
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
        
          body: Stack(
            children: [
              PageView(
          controller: _pageController,
          children: [
            const ToDoList(),
            const NotesView(),
            ChatbotPage(userId: userId,),
          ],
          onPageChanged: (index) {
            setState(() => _currentPage = index);
          },
              ),
          
              // ✅ DRAGGABLE "I'M BORED" BUTTON
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
                    create: (_) => BoredBloc(
                      BoredRepository(ApiClient()),
                    ),
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
              child: const Icon(
                Icons.casino,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
              ),
            ],
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
      
      ),
    );
  }

  void _showChatHistory(BuildContext context) async {
  final chats = await ChatbotService().getChatHistory(userId!);

  if (!mounted) return;

  showModalBottomSheet(
    context: context,
    builder: (_) => ListView(
      children: chats.map((chat) {
        return ListTile(
          title: Text(
            chat["lastMessage"]!.isEmpty
                ? "Untitled Chat"
                : chat["lastMessage"]!,
          ),
          subtitle: const Text("Tap to open • Long press to delete"),
          onTap: () {
            Navigator.pop(context);
            context.read<ChatbotBloc>().add(
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
            Navigator.pop(context);
            _showChatHistory(context);
          },
        );
      }).toList(),
    ),
  );
}

}



