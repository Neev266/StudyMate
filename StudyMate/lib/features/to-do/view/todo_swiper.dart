// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../bloc/todo_bloc.dart';
// import '../bloc/todo_event.dart';
// import '../bloc/todo_state.dart';

// class TodoSwiperPage extends StatelessWidget {
//   final int initialIndex;

//   const TodoSwiperPage({super.key, required this.initialIndex});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("To-Do Details")),
//       body: BlocBuilder<TodoBloc, TodoState>(
//         builder: (context, state) {
//           final todo = state.todos[initialIndex];

//           return Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               children: [
//                 Text(todo.title,
//                     style:
//                         const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 20),
//                 Text(todo.description),
//                 const Spacer(),
//                 ElevatedButton(
//                   child: const Text("Delete"),
//                   onPressed: () {
//                     context.read<TodoBloc>().add(DeleteTodoEvent(initialIndex));
//                     Navigator.pop(context);
//                   },
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
