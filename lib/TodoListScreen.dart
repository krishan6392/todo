import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:todo_list_app/model.dart';
import 'package:todo_list_app/utilis/AppColors.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<Task> tasks = [];
  final TextEditingController taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  // Load tasks from SharedPreferences
  void _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksJson = prefs.getString('tasks');

    if (tasksJson != null) {
      final List<dynamic> decodedTasks = jsonDecode(tasksJson);
      setState(() {
        tasks.clear();
        tasks.addAll(decodedTasks.map((item) => Task.fromJson(item)).toList());
      });
    }
  }

  // Save tasks to SharedPreferences
  void _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String tasksJson =
        jsonEncode(tasks.map((task) => task.toJson()).toList());
    await prefs.setString('tasks', tasksJson);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tasks saved!')),
    );
  }

  void _addTask() {
    if (taskController.text.trim().isNotEmpty) {
      setState(() {
        tasks.add(Task(title: taskController.text.trim()));
        taskController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task title cannot be empty')),
      );
    }
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      tasks[index].isCompleted = !tasks[index].isCompleted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.PRIMARY_COLOR,
        title: const Text(
          'To-Do List',
          style: TextStyle(color: AppColors.WHITE_COLOR),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.WHITE_COLOR,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {
                _saveTasks();
              },
              child: const Text(
                'Save',
                style: TextStyle(
                  color: AppColors.BLACK_COLOR,
                ),
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: taskController,
                    decoration: const InputDecoration(labelText: 'New Task'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addTask,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tasks[index].title,
                        // style: TextStyle(
                        //   decoration: tasks[index].isCompleted
                        //       ? TextDecoration.lineThrough
                        //       : TextDecoration.none,
                        // ),
                      ),
                      Text(
                        tasks[index].isCompleted ? 'Completed' : 'Incomplete',
                        style: TextStyle(
                            color: tasks[index].isCompleted
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 10),
                      ),
                    ],
                  ),
                  trailing: Checkbox(
                    value: tasks[index].isCompleted,
                    onChanged: (bool? value) {
                      _toggleTaskCompletion(index);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
