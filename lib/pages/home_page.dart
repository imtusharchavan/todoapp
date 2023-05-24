import 'package:flutter/material.dart';
import 'package:todoapp/models/todo.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ToDo> todos = [];

  late TextEditingController newTodoTitleController;
  late TextEditingController newTodoContentController;

  @override
  void initState() {
    super.initState();

    newTodoTitleController = TextEditingController();
    newTodoContentController = TextEditingController();
  }

  @override
  void dispose() {
    newTodoTitleController.dispose();
    newTodoContentController.dispose();

    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("To Do App"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => SimpleDialog(
              title: const Text("Add new Todo"),
              contentPadding: const EdgeInsets.all(15),
              children: [
                TextField(
                  controller: newTodoTitleController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Title",
                  ),
                ),               const SizedBox(height: 10),
                TextField(
                  controller: newTodoContentController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Content",
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      todos.add(
                        ToDo(
                          title: newTodoTitleController.text,
                          content: newTodoContentController.text,
                          completed: false,
                          from: DateTime.now(),
                        ),
                      );
                    });

                    newTodoTitleController.clear();
                    newTodoContentController.clear();

                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.done_rounded),
                  label: const Text("Add Todo"),
                ),
              ],
            ),
          );
        },
        label: const Text("Add Todo"),
        icon: const Icon(Icons.add_rounded),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: ListView.separated(
            itemBuilder: (context, index) => ListTile(
                  title: Text(todos[index].title),
                  subtitle: Text(todos[index].content),
                  trailing: IconButton(
                    onPressed: () {
                      final todo = todos[index];
                      setState(() {
                        todos[index] = ToDo(
                          title: todo.title,
                          content: todo.content,
                          completed: !todo.completed,
                          from: todo.from,
                        );
                      });
                    },
                    icon: Icon(
                      todos[index].completed
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                    ),
                  ),
                  tileColor: Theme.of(context).colorScheme.primaryContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
            separatorBuilder: (context, index) => const SizedBox(
            height: 10,
          ),
            itemCount: todos.length),
      ),
    );
  }
}
