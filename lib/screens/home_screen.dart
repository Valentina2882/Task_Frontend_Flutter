import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/theme_service.dart';
import '../widgets/task_filters.dart';
import '../widgets/task_list.dart';
import '../widgets/create_task_dialog.dart';
import '../widgets/gradient_background.dart';

/// Pantalla principal de la aplicación
/// Muestra la lista de tareas y permite gestionarlas
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showThemeSelector(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context, listen: false);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar Tema'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: themeService.themes.asMap().entries.map((entry) {
              final index = entry.key;
              final theme = entry.value;
              final isSelected = index == themeService.currentThemeIndex;
              
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: theme['gradient'],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  title: Text(
                    theme['name'],
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected ? Icon(Icons.check, color: theme['primary']) : null,
                  onTap: () {
                    themeService.setTheme(index);
                    Navigator.pop(context);
                  },
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 400;
    
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        final currentTheme = themeService.currentTheme;
        
        return Scaffold(
          body: GradientBackground(
            colors: themeService.gradientColors,
            child: SafeArea(
              child: Column(
                children: [
                  // Header con título, botón de tema y logout
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 15 : 20, 
                      vertical: isSmallScreen ? 10 : 15
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            'Mis Tareas',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isSmallScreen ? 22 : 28,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            // Botón de cambio de tema
                            IconButton(
                              onPressed: () => _showThemeSelector(context),
                              icon: Icon(
                                Icons.palette, 
                                color: Colors.white, 
                                size: isSmallScreen ? 20 : 24
                              ),
                              tooltip: 'Cambiar tema',
                              padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
                              constraints: BoxConstraints(
                                minWidth: isSmallScreen ? 36 : 40,
                                minHeight: isSmallScreen ? 36 : 40,
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Botón de logout
                            IconButton(
                              onPressed: () {
                                context.read<AuthService>().logout();
                                Navigator.pushReplacementNamed(context, '/login');
                              },
                              icon: Icon(
                                Icons.logout, 
                                color: Colors.white, 
                                size: isSmallScreen ? 20 : 24
                              ),
                              tooltip: 'Cerrar sesión',
                              padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
                              constraints: BoxConstraints(
                                minWidth: isSmallScreen ? 36 : 40,
                                minHeight: isSmallScreen ? 36 : 40,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Contenedor principal con filtros y lista
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 10 : 20
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5).withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(
                          isSmallScreen ? 20 : 25
                        ),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                            spreadRadius: 2,
                          ),
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Filtros de tareas
                          Padding(
                            padding: EdgeInsets.all(isSmallScreen ? 15 : 20),
                            child: const TaskFilters(),
                          ),
                          
                          // Lista de tareas con scroll
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: isSmallScreen ? 15 : 20
                              ),
                              child: const TaskList(),
                            ),
                          ),
                          
                          // Espacio para el botón flotante
                          SizedBox(height: isSmallScreen ? 60 : 80),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Botón flotante para crear tarea
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const CreateTaskDialog(),
              );
            },
            icon: Icon(Icons.add, size: isSmallScreen ? 20 : 24),
            label: Text(
              'Nueva Tarea',
              style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
            ),
            backgroundColor: currentTheme['primary'],
            foregroundColor: Colors.white,
            extendedPadding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 16 : 20,
              vertical: isSmallScreen ? 12 : 16,
            ),
          ),
        );
      },
    );
  }
}
