import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/task_model.dart';

class TaskService {
  final String baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000/';

  Future<List<Task>> getTasks(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/tasks'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List list =
          decoded is List ? decoded : (decoded['items'] ?? decoded['data'] ?? []) as List;
      return list.map((json) => Task.fromJson(json as Map<String, dynamic>)).toList();
    }

    if (response.statusCode == 401) {
      throw Exception('No autorizado. Inicia sesión nuevamente.');
    }

    throw Exception('Error al obtener tareas (${response.statusCode})');
  }

  Future<void> addTask(Task task, String token, bool isCompleted) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tasks'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        ...task.toJson(),
        'isCompleted': isCompleted,
      }),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('No se pudo crear la tarea (${response.statusCode})');
    }
  }

  Future<void> deleteTask(String id, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/tasks/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('No se pudo eliminar la tarea (${response.statusCode})');
    }
  }

  Future<void> updateTask(String id, Task task, String token, bool isCompleted) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/tasks/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        ...task.toJson(),
        'isCompleted': isCompleted,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('No se pudo actualizar la tarea (${response.statusCode})');
    }
  }
}