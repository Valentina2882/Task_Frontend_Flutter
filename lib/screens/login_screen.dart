import 'package:flutter/material.dart';
import '../widgets/app_header.dart';
import '../widgets/login_form.dart';
import '../widgets/gradient_background.dart';

/// Pantalla de inicio de sesión
/// Muestra un formulario para que los usuarios puedan autenticarse
class LoginScreen extends StatelessWidget {
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
                    title: 'Bienvenido',
                    subtitle: 'Inicia sesión para continuar',
                  ),
                  
                  SizedBox(height: isSmallScreen ? 30 : 50),
                  
                  // Contenedor alto con el formulario
                  Container(
                    width: double.infinity,
                    constraints: BoxConstraints(
                      minHeight: isSmallScreen ? 180 : 208,
                      maxHeight: isSmallScreen ? 280 : 308,
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
                        LoginForm(),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: isSmallScreen ? 25 : 45),
                  
                  // Enlace para registrarse
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          '¿No tienes cuenta? ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isSmallScreen ? 14 : 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushReplacementNamed(context, '/register'),
                        child: Text(
                          'Regístrate aquí',
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
