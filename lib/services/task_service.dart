import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/task.dart';
import 'auth_service.dart';

/// Servicio que maneja todas las operaciones relacionadas con tareas
/// Incluye CRUD completo y comunicación con el backend
class TaskService extends ChangeNotifier {
  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _error;

  // Getters para acceder al estado del servicio
  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // URL base del backend
  static const String baseUrl = 'https://taskbackendnestjs-production.up.railway.app';

  /// Obtiene todas las tareas del usuario autenticado
  /// Opcionalmente puede filtrar por estado y búsqueda
  Future<List<Task>> getTasks({
    TaskStatus? status,
    String? search,
    required AuthService authService,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final queryParams = <String, String>{};
      if (status != null) {
        queryParams['status'] = status.toString().split('.').last;
      }
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final uri = Uri.parse('$baseUrl/tasks').replace(queryParameters: queryParams);
      final headers = authService.getAuthHeaders();
      
      print('📋 Getting tasks from: $uri');
      print('🔑 Auth headers: $headers');
      print('🔑 Access token: ${authService.accessToken}');

      final response = await http.get(
        uri,
        headers: headers,
      );

      print('📥 Tasks response status: ${response.statusCode}');
      print('📥 Tasks response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _tasks = data.map((json) => Task.fromJson(json)).toList();
        _setLoading(false);
        notifyListeners();
        return _tasks;
      } else {
        _setError('Error al obtener las tareas (Status: ${response.statusCode})');
        return [];
      }
    } catch (e) {
      _setError('Error de conexión: $e');
      print('❌ Get tasks error: $e');
      return [];
    }
  }

  /// Obtiene una tarea específica por su ID
  Future<Task?> getTaskById(int id, AuthService authService) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/tasks/$id'),
        headers: authService.getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Task.fromJson(data);
      } else {
        _setError('Tarea no encontrada');
        return null;
      }
    } catch (e) {
      _setError('Error de conexión: $e');
      return null;
    }
  }

  /// Crea una nueva tarea
  Future<Task?> createTask({
    required String title,
    required String description,
    required AuthService authService,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final url = '$baseUrl/tasks';
      final body = json.encode({
        'title': title,
        'description': description,
      });
      final headers = authService.getAuthHeaders();
      
      print('📝 Creating task at: $url');
      print('📤 Request body: $body');
      print('🔑 Auth headers: $headers');
      print('🔑 Access token: ${authService.accessToken}');

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      print('📥 Create task response status: ${response.statusCode}');
      print('📥 Create task response body: ${response.body}');

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        final newTask = Task.fromJson(data);
        _tasks.add(newTask);
        _setLoading(false);
        notifyListeners();
        print('✅ Task created successfully');
        return newTask;
      } else {
        _setError('Error al crear la tarea (Status: ${response.statusCode})');
        print('❌ Create task failed: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      _setError('Error de conexión: $e');
      print('❌ Create task error: $e');
      return null;
    }
  }

  /// Actualiza el estado de una tarea existente
  Future<Task?> updateTaskStatus({
    required int taskId,
    required TaskStatus status,
    required AuthService authService,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/tasks/$taskId/status'),
        headers: authService.getAuthHeaders(),
        body: json.encode({
          'status': status.toString().split('.').last,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final updatedTask = Task.fromJson(data);
        
        // Actualizar la tarea en la lista local
        final index = _tasks.indexWhere((task) => task.id == taskId);
        if (index != -1) {
          _tasks[index] = updatedTask;
        }
        
        _setLoading(false);
        notifyListeners();
        return updatedTask;
      } else {
        _setError('Error al actualizar la tarea');
        return null;
      }
    } catch (e) {
      _setError('Error de conexión: $e');
      return null;
    }
  }

  /// Elimina una tarea existente
  Future<bool> deleteTask(int taskId, AuthService authService) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/tasks/$taskId'),
        headers: authService.getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        // Remover la tarea de la lista local
        _tasks.removeWhere((task) => task.id == taskId);
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _setError('Error al eliminar la tarea');
        return false;
      }
    } catch (e) {
      _setError('Error de conexión: $e');
      return false;
    }
  }

  /// Filtra las tareas por estado
  List<Task> getTasksByStatus(TaskStatus status) {
    return _tasks.where((task) => task.status == status).toList();
  }

  /// Busca tareas por texto en título o descripción
  List<Task> searchTasks(String query) {
    final lowercaseQuery = query.toLowerCase();
    return _tasks.where((task) =>
        task.title.toLowerCase().contains(lowercaseQuery) ||
        task.description.toLowerCase().contains(lowercaseQuery)).toList();
  }

  /// Métodos privados para manejar el estado interno
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    _isLoading = false;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}
