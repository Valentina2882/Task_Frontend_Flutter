import 'package:http/http.dart' as http;
import 'auth_service.dart';

/// Interceptor HTTP para manejar automáticamente la validación de tokens
/// y redirigir al login cuando sea necesario
class HttpInterceptor {
  final AuthService authService;

  HttpInterceptor(this.authService);

  /// Realiza una petición GET con validación automática de token
  Future<http.Response> get(String url, {Map<String, String>? headers}) async {
    // Validar token antes de hacer la petición
    if (!authService.validateToken()) {
      throw AuthException('Token inválido o expirado');
    }

    final response = await http.get(
      Uri.parse(url),
      headers: headers ?? authService.getAuthHeaders(),
    );

    // Manejar errores de autenticación
    if (response.statusCode == 401) {
      authService.logout();
      throw AuthException('Sesión expirada. Por favor, inicia sesión nuevamente.');
    }

    return response;
  }

  /// Realiza una petición POST con validación automática de token
  Future<http.Response> post(String url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    // Validar token antes de hacer la petición
    if (!authService.validateToken()) {
      throw AuthException('Token inválido o expirado');
    }

    final response = await http.post(
      Uri.parse(url),
      headers: headers ?? authService.getAuthHeaders(),
      body: body,
    );

    // Manejar errores de autenticación
    if (response.statusCode == 401) {
      authService.logout();
      throw AuthException('Sesión expirada. Por favor, inicia sesión nuevamente.');
    }

    return response;
  }

  /// Realiza una petición PUT con validación automática de token
  Future<http.Response> put(String url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    // Validar token antes de hacer la petición
    if (!authService.validateToken()) {
      throw AuthException('Token inválido o expirado');
    }

    final response = await http.put(
      Uri.parse(url),
      headers: headers ?? authService.getAuthHeaders(),
      body: body,
    );

    // Manejar errores de autenticación
    if (response.statusCode == 401) {
      authService.logout();
      throw AuthException('Sesión expirada. Por favor, inicia sesión nuevamente.');
    }

    return response;
  }

  /// Realiza una petición PATCH con validación automática de token
  Future<http.Response> patch(String url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    // Validar token antes de hacer la petición
    if (!authService.validateToken()) {
      throw AuthException('Token inválido o expirado');
    }

    final response = await http.patch(
      Uri.parse(url),
      headers: headers ?? authService.getAuthHeaders(),
      body: body,
    );

    // Manejar errores de autenticación
    if (response.statusCode == 401) {
      authService.logout();
      throw AuthException('Sesión expirada. Por favor, inicia sesión nuevamente.');
    }

    return response;
  }

  /// Realiza una petición DELETE con validación automática de token
  Future<http.Response> delete(String url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    // Validar token antes de hacer la petición
    if (!authService.validateToken()) {
      throw AuthException('Token inválido o expirado');
    }

    final response = await http.delete(
      Uri.parse(url),
      headers: headers ?? authService.getAuthHeaders(),
      body: body,
    );

    // Manejar errores de autenticación
    if (response.statusCode == 401) {
      authService.logout();
      throw AuthException('Sesión expirada. Por favor, inicia sesión nuevamente.');
    }

    return response;
  }
}

/// Excepción personalizada para errores de autenticación
class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}
