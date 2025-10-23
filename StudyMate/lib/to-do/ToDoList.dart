import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_app/to-do/todo_service.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  void _openAddDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Wrap(
                runSpacing: 12,
                children: [
                  const Center(
                    child: Text(
                      'Add To-Do',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  TextField(
                    controller: descController,
                    minLines: 2,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final title = titleController.text.trim();
                          final desc = descController.text.trim();
                          if (title.isEmpty) return;

                          Provider.of<TodoService>(context, listen: false)
                              .addTodo(title, desc.isEmpty ? '' : desc);

                          Navigator.pop(context);
                        },
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Swiper page (opened when a todo is tapped)
  void _openSwiperPage(BuildContext context, int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TodoSwiperPage(initialIndex: initialIndex),
      ),
    );
  }

  Widget _buildTodoCard(Todo todo, int index) {
    final colors = [
      Colors.red[400],
      Colors.green[100],
      Colors.orangeAccent,
    ];

    return GestureDetector(
      onTap: () => _openSwiperPage(context, index),
      child: SizedBox(
        width: 170,
        child: Card(
          key: ValueKey(todo.createdAt),
          color: colors[index % colors.length],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  todo.title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  todo.description,
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<TodoService>(
        builder: (context, todoService, _) {
          final todos = todoService.todos;

          if (todos.isEmpty) {
            return const Center(
              child: Text('No todos yet. Tap + to add one.'),
            );
          }

          return MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            padding: const EdgeInsets.all(12),
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];

              return Dismissible(
                key: ValueKey(todo.createdAt),
                direction: DismissDirection.endToStart,
                onDismissed: (_) {
                  todoService.removeTodoAt(index);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Todo removed')),
                  );
                },
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: _buildTodoCard(todo, index),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// 🌀 Fullscreen swiper page
class TodoSwiperPage extends StatefulWidget {
  final int initialIndex;
  const TodoSwiperPage({super.key, required this.initialIndex});

  @override
  State<TodoSwiperPage> createState() => _TodoSwiperPageState();
}

class _TodoSwiperPageState extends State<TodoSwiperPage> {
  late final CardSwiperController controller;
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    controller = CardSwiperController();
    currentIndex = widget.initialIndex;
  }

  void _openEditSheet(BuildContext context, Todo todo, int index) {
    final titleController = TextEditingController(text: todo.title);
    final descController = TextEditingController(text: todo.description);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Wrap(
                runSpacing: 12,
                children: [
                  const Center(
                    child: Text(
                      'Edit To-Do',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  TextField(
                    controller: descController,
                    minLines: 2,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final newTitle = titleController.text.trim();
                          final newDesc = descController.text.trim();
                          if (newTitle.isEmpty) return;

                          Provider.of<TodoService>(context, listen: false)
                              .updateTodo(index as String, newTitle, newDesc);
                          Navigator.pop(context);
                          setState(() {});
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final todos = Provider.of<TodoService>(context).todos;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your To-Dos'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: CardSwiper(
          controller: controller,
          initialIndex: widget.initialIndex,
          cardsCount: todos.length,
          numberOfCardsDisplayed: 1,
          onSwipe: (prev, next, direction) {
            setState(() => currentIndex = next ?? currentIndex);
            return true;
          },
          cardBuilder: (context, index, percentX, percentY) {
            final todo = todos[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 6,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      todo.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      todo.description.isNotEmpty
                          ? todo.description
                          : 'No description',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: () => _openEditSheet(context, todo, index),
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit To-Do'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
