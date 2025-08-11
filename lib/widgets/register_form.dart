import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../utils/navigation.dart';

/// Widget que maneja el formulario de registro
class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

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
      final authService = Provider.of<AuthService>(context, listen: false);
      
      final success = await authService.register(
        _usernameController.text.trim(),
        _passwordController.text,
      );

      if (success && context.mounted) {
        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Usuario registrado exitosamente'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        
        // Esperar un momento y luego redirigir al login
        await Future.delayed(Duration(milliseconds: 1500));
        
        // Redirigir al login después del registro exitoso
        if (context.mounted) {
          _navigateToLogin();
        }
      } else if (!success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authService.error ?? 'Error en el registro'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Método para navegar al login de manera segura
  void _navigateToLogin() {
    try {
      // Intentar navegar usando el Navigator del contexto
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/login',
        (route) => false,
      );
    } catch (e) {
      print('Error navegando al login: $e');
      // Fallback: usar el navigatorKey global
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        '/login',
        (route) => false,
      );
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
    
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Campo de username
          TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: 'Nombre de usuario',
              labelStyle: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w500,
                fontSize: isSmallScreen ? 14 : 16,
              ),
              prefixIcon: Icon(Icons.person, color: Colors.black54, size: isSmallScreen ? 20 : 24),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 15),
                borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 15),
                borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 15),
                borderSide: BorderSide(color: Color(0xFF4A148C), width: 2),
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.9),
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
            decoration: InputDecoration(
              labelText: 'Contraseña',
              labelStyle: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w500,
                fontSize: isSmallScreen ? 14 : 16,
              ),
              prefixIcon: Icon(Icons.lock, color: Colors.black54, size: isSmallScreen ? 20 : 24),
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
                borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 15),
                borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 15),
                borderSide: BorderSide(color: Color(0xFF4A148C), width: 2),
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.9),
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
            decoration: InputDecoration(
              labelText: 'Confirmar contraseña',
              labelStyle: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w500,
                fontSize: isSmallScreen ? 14 : 16,
              ),
              prefixIcon: Icon(Icons.lock_outline, color: Colors.black54, size: isSmallScreen ? 20 : 24),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                  color: Colors.black54,
                  size: isSmallScreen ? 20 : 24,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 15),
                borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 15),
                borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 15),
                borderSide: BorderSide(color: Color(0xFF4A148C), width: 2),
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.9),
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
          Consumer<AuthService>(
            builder: (context, authService, child) {
              return Container(
                width: double.infinity,
                height: isSmallScreen ? 45 : 55,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
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
                      color: Color(0xFF4A148C).withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: authService.isLoading ? null : _handleRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 15),
                    ),
                  ),
                  child: authService.isLoading
                      ? CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        )
                      : Text(
                          '✨ Registrarse',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 16 : 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
