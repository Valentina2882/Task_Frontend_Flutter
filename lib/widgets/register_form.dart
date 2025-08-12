import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/auth_service.dart';

/// Widget que maneja el formulario de registro
class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  RegisterFormState createState() => RegisterFormState();
}

class RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _registroExitoso = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Maneja el proceso de registro
  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      Provider.of<AuthService>(context, listen: false);
      try {
        // Hacer la petición HTTP directamente sin usar el AuthService problemático
        const url = 'https://taskbackendnestjs-production.up.railway.app/auth/signup';
        final body = json.encode({
          'username': _usernameController.text.trim(),
          'password': _passwordController.text,
        });
        
        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
          },
          body: body,
        );
        
        if (response.statusCode == 201){
          if (mounted) {
            setState(() {
              _registroExitoso = true;
              _isLoading = false;
            });
          }
        } else if (response.statusCode == 409) {
          setState(() {
            _isLoading = false;
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('El nombre de usuario ya existe'),
                backgroundColor: Colors.red,
              ),
            );
          }
        } else {
          setState(() {
            _isLoading = false;
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error en el registro: ${response.statusCode}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error inesperado: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  /// Valida que la contraseña cumpla con los requisitos del backend
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa una contraseña';
    }
    if (value.length < 3) {
      return 'La contraseña debe tener al menos 3 caracteres';
    }
    if (value.length > 20) {
      return 'La contraseña no puede tener más de 20 caracteres';
    }
    
    final hasUpperCase = RegExp(r'[A-Z]').hasMatch(value);
    final hasLowerCase = RegExp(r'[a-z]').hasMatch(value);
    final hasNumbers = RegExp(r'[0-9]').hasMatch(value);
    final hasSpecialCharacters = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value);
    
    if (!hasUpperCase || !hasLowerCase || (!hasNumbers && !hasSpecialCharacters)) {
      return 'La contraseña debe contener al menos 1 mayúscula, 1 minúscula y 1 número o carácter especial';
    }
    
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 400;

    if (_registroExitoso) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.green, size: 64),
              const SizedBox(height: 24),
              const Text(
                '¡Registro completado! Ahora puedes iniciar sesión.',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                },
                child: const Text('Ir a iniciar sesión'),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.yellow[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber, width: 1.5),
                ),
                child: const Text(
                  'Nota: Si usas la versión desplegada en Vercel, la navegación automática puede no funcionar correctamente. Por favor, navega manualmente al login si no eres redirigido.',
                  style: TextStyle(color: Colors.black87, fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Campo de username
          TextFormField(
            controller: _usernameController,
            enabled: !_registroExitoso,
            decoration: InputDecoration(
              labelText: 'Nombre de usuario',
              labelStyle: const TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              prefixIcon: const Icon(Icons.person, color: Colors.black54, size: 24),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 15),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 15),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 15),
                borderSide: const BorderSide(color: Color(0xFF4A148C), width: 2),
              ),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.9),
              contentPadding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 15 : 20, 
                vertical: isSmallScreen ? 12 : 18
              ),
            ),
            style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa un nombre de usuario';
              }
              if (value.length < 4) {
                return 'El nombre de usuario debe tener al menos 4 caracteres';
              }
              if (value.length > 20) {
                return 'El nombre de usuario no puede tener más de 20 caracteres';
              }
              return null;
            },
          ),
          SizedBox(height: isSmallScreen ? 15 : 20),

          // Campo de password
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            enabled: !_registroExitoso,
            decoration: InputDecoration(
              labelText: 'Contraseña',
              labelStyle: const TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              prefixIcon: const Icon(Icons.lock, color: Colors.black54, size: 24),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  color: Colors.black54,
                  size: isSmallScreen ? 20 : 24,
                ),
                onPressed: !_registroExitoso ? () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                } : null,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 15),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 15),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 15),
                borderSide: const BorderSide(color: Color(0xFF4A148C), width: 2),
              ),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.9),
              contentPadding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 15 : 20, 
                vertical: isSmallScreen ? 12 : 18
              ),
            ),
            style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
            validator: _validatePassword,
          ),
          SizedBox(height: isSmallScreen ? 15 : 20),

          // Campo de confirmar password
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            enabled: !_registroExitoso,
            decoration: InputDecoration(
              labelText: 'Confirmar contraseña',
              labelStyle: const TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              prefixIcon: const Icon(Icons.lock_outline, color: Colors.black54, size: 24),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                  color: Colors.black54,
                  size: isSmallScreen ? 20 : 24,
                ),
                onPressed: !_registroExitoso ? () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                } : null,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 15),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 15),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 15),
                borderSide: const BorderSide(color: Color(0xFF4A148C), width: 2),
              ),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.9),
              contentPadding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 15 : 20, 
                vertical: isSmallScreen ? 12 : 18
              ),
            ),
            style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor confirma tu contraseña';
              }
              if (value != _passwordController.text) {
                return 'Las contraseñas no coinciden';
              }
              return null;
            },
          ),
          SizedBox(height: isSmallScreen ? 20 : 30),

          // Botón de registro con gradiente
          Container(
            width: double.infinity,
            height: isSmallScreen ? 45 : 55,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF4A148C), // Morado muy oscuro
                  Color(0xFF6A1B9A), // Morado oscuro
                  Color(0xFF8E24AA), // Morado medio
                ],
              ),
              borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 15),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4A148C).withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: (!_registroExitoso && !_isLoading) ? _handleRegister : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 15),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    )
                  : const Text(
                      '✨ Registrarse',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
