import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/task_service.dart';
import '../services/auth_service.dart';
import '../models/task.dart';
import 'task_item.dart';
import 'empty_tasks.dart';

/// Widget que muestra la lista de tareas
class TaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskService>(
      builder: (context, taskService, child) {
        if (taskService.isLoading) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF5F5F5)),
            ),
          );
        }

        if (taskService.tasks.isEmpty) {
          return EmptyTasks();
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 8),
          itemCount: taskService.tasks.length,
          itemBuilder: (context, index) {
            final task = taskService.tasks[index];
            return Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: TaskItem(
                task: task,
                onTaskUpdated: () {
                  // Recargar tareas cuando se actualiza una
                  final authService = Provider.of<AuthService>(context, listen: false);
                  taskService.getTasks(authService: authService);
                },
              ),
            );
          },
        );
      },
    );
  }
}
