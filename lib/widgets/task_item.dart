import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../services/task_service.dart';
import '../services/auth_service.dart';
import '../services/theme_service.dart';
import '../utils/navigation.dart'; // Importar navigatorKey desde utils

/// Widget que muestra una tarea individual
class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onTaskUpdated;

  const TaskItem({
    Key? key,
    required this.task,
    required this.onTaskUpdated,
  }) : super(key: key);

  /// Actualiza el estado de una tarea
  Future<void> _updateTaskStatus(TaskStatus newStatus) async {
    final taskService = Provider.of<TaskService>(navigatorKey.currentContext!, listen: false);
    final authService = Provider.of<AuthService>(navigatorKey.currentContext!, listen: false);

    final success = await taskService.updateTaskStatus(
      taskId: task.id,
      status: newStatus,
      authService: authService,
    );

    if (success != null) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text('Estado actualizado'),
          backgroundColor: Colors.green,
        ),
      );
      onTaskUpdated();
    } else {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text(taskService.error ?? 'Error al actualizar'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Elimina una tarea
  Future<void> _deleteTask() async {
    final confirmed = await showDialog<bool>(
      context: navigatorKey.currentContext!,
      builder: (context) => AlertDialog(
        title: Text('Eliminar Tarea'),
        content: Text('¿Estás seguro de que quieres eliminar esta tarea?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final taskService = Provider.of<TaskService>(navigatorKey.currentContext!, listen: false);
      final authService = Provider.of<AuthService>(navigatorKey.currentContext!, listen: false);

      final success = await taskService.deleteTask(task.id, authService);

      if (success) {
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          SnackBar(
            content: Text('Tarea eliminada'),
            backgroundColor: Colors.green,
          ),
        );
        onTaskUpdated();
      } else {
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          SnackBar(
            content: Text(taskService.error ?? 'Error al eliminar'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 400;
    
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return Card(
          margin: EdgeInsets.only(bottom: 12),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 15),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 15 : 20,
              vertical: isSmallScreen ? 8 : 12,
            ),
            title: Text(
              task.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isSmallScreen ? 16 : 18,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Text(
                  task.description,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 10 : 12,
                    vertical: isSmallScreen ? 6 : 8,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(task.status, themeService),
                    borderRadius: BorderRadius.circular(isSmallScreen ? 15 : 20),
                    boxShadow: [
                      BoxShadow(
                        color: _getStatusColor(task.status, themeService).withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getStatusIcon(task.status),
                        color: Colors.white,
                        size: isSmallScreen ? 16 : 18,
                      ),
                      SizedBox(width: 6),
                      Text(
                        task.status.displayName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isSmallScreen ? 12 : 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            trailing: PopupMenuButton<dynamic>(
              icon: Icon(
                Icons.more_vert,
                color: Colors.black54,
                size: isSmallScreen ? 20 : 24,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 8,
              itemBuilder: (context) => <PopupMenuEntry<dynamic>>[
                ...TaskStatus.values.map((status) => PopupMenuItem<dynamic>(
                  value: status,
                  child: Row(
                    children: [
                      Icon(
                        _getStatusIcon(status),
                        color: _getStatusColor(status, themeService),
                        size: isSmallScreen ? 18 : 20,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Marcar como ${status.displayName}',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 14 : 16,
                          fontWeight: task.status == status ? FontWeight.bold : FontWeight.normal,
                          color: task.status == status ? themeService.primaryColor : null,
                        ),
                      ),
                    ],
                  ),
                )),
                PopupMenuDivider(),
                PopupMenuItem<dynamic>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                        size: isSmallScreen ? 18 : 20,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Eliminar',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: isSmallScreen ? 14 : 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 'delete') {
                  _deleteTask();
                } else if (value is TaskStatus) {
                  _updateTaskStatus(value);
                }
              },
            ),
          ),
        );
      },
    );
  }

  /// Obtiene el color correspondiente al estado de la tarea
  Color _getStatusColor(TaskStatus status, ThemeService themeService) {
    switch (status) {
      case TaskStatus.OPEN:
        return Color(0xFFE57373); // Rojo suave
      case TaskStatus.IN_PROGRESS:
        return themeService.accentColor; // Usar color de acento del tema
      case TaskStatus.DONE:
        return Color(0xFF81C784); // Verde suave
    }
  }

  /// Obtiene el ícono correspondiente al estado de la tarea
  IconData _getStatusIcon(TaskStatus status) {
    switch (status) {
      case TaskStatus.OPEN:
        return Icons.radio_button_unchecked;
      case TaskStatus.IN_PROGRESS:
        return Icons.pending;
      case TaskStatus.DONE:
        return Icons.check_circle;
    }
  }
}
