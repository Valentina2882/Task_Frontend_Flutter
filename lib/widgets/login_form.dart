import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

/// Widget que maneja el formulario de inicio de sesión
class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Maneja el proceso de login
  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final authService = Provider.of<AuthService>(context, listen: false);
      
      final success = await authService.login(
        _usernameController.text.trim(),
        _passwordController.text,
      );

      if (success) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authService.error ?? 'Error en el login'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 400;
    
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Campo de username
          TextFormField(
            controller: _usernameController,
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
                return 'Por favor ingresa tu nombre de usuario';
              }
              if (value.length < 4) {
                return 'El nombre de usuario debe tener al menos 4 caracteres';
              }
              return null;
            },
          ),
          SizedBox(height: isSmallScreen ? 15 : 20),

          // Campo de password
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
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
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
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
                return 'Por favor ingresa tu contraseña';
              }
              if (value.length < 3) {
                return 'La contraseña debe tener al menos 3 caracteres';
              }
              return null;
            },
          ),
          SizedBox(height: isSmallScreen ? 20 : 30),

          // Botón de login con gradiente
          Consumer<AuthService>(
            builder: (context, authService, child) {
              return Container(
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
                  onPressed: authService.isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 15),
                    ),
                  ),
                  child: authService.isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        )
                      : const Text(
                          '🚀 Iniciar Sesión',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              );
            },
          ),
          
          SizedBox(height: isSmallScreen ? 15 : 20),
        ],
      ),
    );
  }
}
