import 'package:flutter/material.dart';
import '../widgets/app_header.dart';
import '../widgets/register_form.dart';
import '../widgets/gradient_background.dart';

/// Pantalla de registro de usuarios
/// Permite a los usuarios crear una nueva cuenta
class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 400;
    
    return Scaffold(
      body: GradientBackground(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 15 : 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Header con logo y título
                  AppHeader(
                    title: 'Crear Cuenta',
                    subtitle: 'Regístrate para comenzar',
                  ),
                  
                  SizedBox(height: isSmallScreen ? 30 : 50),
                  
                  // Contenedor alto con el formulario
                  Container(
                    width: double.infinity,
                    constraints: BoxConstraints(
                      minHeight: isSmallScreen ? 220 : 270,
                      maxHeight: isSmallScreen ? 320 : 370,
                    ),
                    padding: EdgeInsets.all(isSmallScreen ? 20 : 30),
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F5F5).withOpacity(0.95),
                      borderRadius: BorderRadius.circular(isSmallScreen ? 20 : 25),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                          spreadRadius: 2,
                        ),
                        BoxShadow(
                          color: Colors.white.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RegisterForm(),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: isSmallScreen ? 25 : 45),
                  
                  // Enlace para iniciar sesión
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          '¿Ya tienes cuenta? ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isSmallScreen ? 14 : 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                        child: Text(
                          'Inicia sesión aquí',
                          style: TextStyle(
                            color: Color(0xFFF5F5F5),
                            fontSize: isSmallScreen ? 14 : 16,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
