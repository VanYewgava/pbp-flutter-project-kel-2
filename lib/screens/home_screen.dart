import 'package:flutter/material.dart';
import 'package:pbp_project_flutter_speedrun/helpers/database_helper.dart';
import 'package:pbp_project_flutter_speedrun/models/task_model.dart';
import 'package:pbp_project_flutter_speedrun/screens/add_task_screen.dart';
import 'package:pbp_project_flutter_speedrun/screens/history_screen.dart';
import 'package:pbp_project_flutter_speedrun/screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Task> taskList = []; 
  @override
  void initState() {
    super.initState();
    updateListView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              ).then((_) => updateListView()); 
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              ).then((_) {
                updateListView(); 
              });
            },
          ),
        ],
      ),
      body: taskList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.task, size: 100, color: Colors.grey[400]),
                  const SizedBox(height: 20),
                  Text(
                    'No active tasks!',
                    style: TextStyle(fontSize: 20, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Tap + to add a new task',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: taskList.length,
              itemBuilder: (BuildContext context, int position) {
                return _buildTaskCard(taskList[position]);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddTask();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    Color priorityColor = _getPriorityColor(task.priority);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: priorityColor,
          child: Text(
            task.priority.isNotEmpty ? task.priority[0] : 'L',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: task.status == 1 ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description != null && task.description!.isNotEmpty)
              Text(task.description!),
            const SizedBox(height: 4),
            Text(
              task.date,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: Checkbox(
          value: task.status == 1,
          onChanged: (bool? value) {
            _completeTask(task, value!);
          },
        ),
        onTap: () {
          _navigateToAddTask(task: task);
        },
      ),
    );
  }

  void _navigateToAddTask({Task? task}) async {
    bool? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTaskScreen(task: task),
      ),
    );
    if (result == true) {
      updateListView();
    }
  }

  void _completeTask(Task task, bool isCompleted) async {
    Task updatedTask = task.copyWith(status: isCompleted ? 1 : 0);
    await databaseHelper.updateTask(updatedTask);
    updateListView();
    if (mounted) {
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text('Task moved to History')),
       );
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Future<void> updateListView() async {
    final List<Task> allTasks = await databaseHelper.getTaskList();
    
    setState(() {
      taskList = allTasks.where((task) => task.status == 0).toList();
    });
  }
}