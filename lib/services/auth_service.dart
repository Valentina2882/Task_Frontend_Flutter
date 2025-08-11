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
  bool get isAuthenticated => _accessToken != null && !_isTokenExpired();

  // URL base del backend
  static const String baseUrl = 'https://taskbackendnestjs-production.up.railway.app';

  /// Valida si el token JWT ha expirado
  bool _isTokenExpired() {
    if (_accessToken == null) return true;
    
    try {
      // Decodificar el token JWT (sin verificar la firma)
      final parts = _accessToken!.split('.');
      if (parts.length != 3) return true;
      
      // Decodificar el payload (segunda parte)
      final payload = parts[1];
      // Agregar padding si es necesario
      final normalized = base64Url.normalize(payload);
      final resp = utf8.decode(base64Url.decode(normalized));
      final payloadMap = json.decode(resp);
      
      // Verificar la expiración
      final exp = payloadMap['exp'];
      if (exp == null) return true;
      
      final expiry = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      final now = DateTime.now();
      
      return now.isAfter(expiry);
    } catch (e) {
      print('❌ Error validando token: $e');
      return true;
    }
  }

  /// Valida el token actual y retorna true si es válido
  bool validateToken() {
    if (_accessToken == null) {
      print('❌ No hay token disponible');
      return false;
    }
    
    if (_isTokenExpired()) {
      print('❌ Token expirado');
      _accessToken = null;
      _currentUser = null;
      notifyListeners();
      return false;
    }
    
    print('✅ Token válido');
    return true;
  }

  /// Verifica la validez del token con el backend
  Future<bool> verifyTokenWithBackend() async {
    if (!validateToken()) return false;
    
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/verify'),
        headers: getAuthHeaders(),
      );
      
      if (response.statusCode == 200) {
        print('✅ Token verificado con el backend');
        return true;
      } else {
        print('❌ Token inválido en el backend: ${response.statusCode}');
        _accessToken = null;
        _currentUser = null;
        notifyListeners();
        return false;
      }
    } catch (e) {
      print('❌ Error verificando token: $e');
      return false;
    }
  }

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
        clearAfterRegister();
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
    } finally {
      // Asegurar que el loading se detenga en caso de error
      if (_isLoading) {
        _setLoading(false);
      }
    }
  }

  /// Cierra la sesión del usuario actual
  void logout() {
    _currentUser = null;
    _accessToken = null;
    _clearError();
    notifyListeners();
  }

  /// Limpia el estado después del registro exitoso
  void clearAfterRegister() {
    _isLoading = false;
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
