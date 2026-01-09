import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart' ;
import 'package:flutter_app/features/Chatbot/bloc/chatbot_bloc.dart';
import 'package:flutter_app/features/Chatbot/data/chatbot_service.dart';
import 'package:flutter_app/features/Notes/bloc/notes_bloc.dart';

import 'package:flutter_app/features/Notes/data/note_service.dart';
import 'package:flutter_app/features/Splash Screen/Splash_Screen.dart';
import 'package:flutter_app/features/Login/view/login_screen.dart';
import 'package:flutter_app/features/Welcome/welcome.dart';
import 'package:flutter_app/features/to-do/bloc/todo_bloc.dart';
import 'package:flutter_app/features/to-do/data/todo_service.dart';
import 'package:flutter_app/firebase_options.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'features/Signin/view/signin_view.dart';
import 'features/Home/home.dart';


void main() async{
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform

  );
  runApp(
    MultiBlocProvider(
      providers: [
       BlocProvider(
        create: (_) => TodoBloc(TodoService()),
       
       ),//provides your todo state to the entire app
       BlocProvider(
        create: (_) => NotesBloc(NotesService()),
        
       ),
       BlocProvider(create: (_)=>ChatbotBloc(ChatbotService()))
      ],
      child: const MyApp(),
    ),
    );
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
        '/signin': (context) => SignupPage(),
        '/login': (context) => LoginScreen(),
        '/welcome':(context) => WelcomePage(),
        
      }
    );
  }
}
