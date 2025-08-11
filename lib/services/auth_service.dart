import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';

/// Servicio que maneja toda la lógica de autenticación
/// Incluye login, registro y gestión del token de acceso
class AuthService extends ChangeNotifier {
  User? _currentUser;
  String? _accessToken;
  bool _isLoading = false;
  String? _error;

  // Getters para acceder al estado del servicio
  User? get currentUser => _currentUser;
  String? get accessToken => _accessToken;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _accessToken != null;

  // URL base del backend
  static const String baseUrl = 'https://taskbackendnestjs-production.up.railway.app';

  /// Realiza el login del usuario
  /// Retorna true si el login es exitoso, false en caso contrario
  Future<bool> login(String username, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final url = '$baseUrl/auth/signin';
      final body = json.encode({
        'username': username,
        'password': password,
      });
      
      print('🔐 Login attempt to: $url');
      print('📤 Request body: $body');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        _accessToken = data['accessToken'];
        
        // Crear usuario temporal (el backend no devuelve el usuario completo en login)
        _currentUser = User(
          id: 0, // Se actualizará cuando se obtenga el perfil completo
          username: username,
          accessToken: _accessToken,
        );
        
        _setLoading(false);
        notifyListeners();
        print('✅ Login successful');
        return true;
      } else {
        _setError('Credenciales incorrectas (Status: ${response.statusCode})');
        print('❌ Login failed: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      _setError('Error de conexión: $e');
      print('❌ Login error: $e');
      return false;
    }
  }

  /// Registra un nuevo usuario
  /// Retorna true si el registro es exitoso, false en caso contrario
  Future<bool> register(String username, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final url = '$baseUrl/auth/signup';
      final body = json.encode({
        'username': username,
        'password': password,
      });
      
      print('📝 Register attempt to: $url');
      print('📤 Request body: $body');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 201) {
        _setLoading(false);
        notifyListeners();
        print('✅ Register successful');
        return true;
      } else if (response.statusCode == 409) {
        _setError('El nombre de usuario ya existe');
        print('❌ Register failed: Username already exists');
        return false;
      } else {
        _setError('Error en el registro (Status: ${response.statusCode})');
        print('❌ Register failed: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      _setError('Error de conexión: $e');
      print('❌ Register error: $e');
      return false;
    }
  }

  /// Cierra la sesión del usuario actual
  void logout() {
    _currentUser = null;
    _accessToken = null;
    _clearError();
    notifyListeners();
  }

  /// Obtiene los headers de autorización para las peticiones
  Map<String, String> getAuthHeaders() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_accessToken',
    };
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
