import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/task_service.dart';
import '../services/auth_service.dart';
import 'task_item.dart';
import 'empty_tasks.dart';

/// Widget que muestra la lista de tareas
class TaskList extends StatelessWidget {
  const TaskList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskService>(
      builder: (context, taskService, child) {
        if (taskService.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF5F5F5)),
            ),
          );
        }

        if (taskService.tasks.isEmpty) {
          return const EmptyTasks();
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: taskService.tasks.length,
          itemBuilder: (context, index) {
            final task = taskService.tasks[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
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
