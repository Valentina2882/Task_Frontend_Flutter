import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/task_service.dart';
import '../services/auth_service.dart';
import '../services/theme_service.dart';
import '../models/task.dart';

/// Widget que maneja los filtros y búsqueda de tareas con efectos visuales
class TaskFilters extends StatefulWidget {
  @override
  _TaskFiltersState createState() => _TaskFiltersState();
}

class _TaskFiltersState extends State<TaskFilters>
    with TickerProviderStateMixin {
  String _searchQuery = '';
  TaskStatus? _filterStatus;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    
    _slideAnimation = Tween<double>(
      begin: -50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
    
    // Cargar tareas al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTasks();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Carga las tareas con los filtros actuales
  Future<void> _loadTasks() async {
    final taskService = Provider.of<TaskService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    await taskService.getTasks(
      status: _filterStatus,
      search: _searchQuery.isNotEmpty ? _searchQuery : null,
      authService: authService,
    );
  }

  /// Maneja el cambio en la búsqueda
  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
    _loadTasks();
  }

  /// Maneja el cambio en el filtro de estado
  void _onFilterChanged(TaskStatus? value) {
    setState(() {
      _filterStatus = value;
    });
    _loadTasks();
  }

  /// Obtiene colores claros del tema
  Color _getLightThemeColor(ThemeService themeService, {double opacity = 0.1}) {
    return themeService.primaryColor.withOpacity(opacity);
  }

  /// Obtiene colores medios del tema
  Color _getMediumThemeColor(ThemeService themeService, {double opacity = 0.3}) {
    return themeService.primaryColor.withOpacity(opacity);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 400;
    final isVerySmallScreen = screenSize.width <= 320; // Para 320x642
    
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _slideAnimation.value),
              child: Opacity(
                opacity: _fadeAnimation.value,
                                 child: Container(
                   padding: EdgeInsets.all(isVerySmallScreen ? 10 : isSmallScreen ? 15 : 20),
                   decoration: BoxDecoration(
                     gradient: LinearGradient(
                       begin: Alignment.topLeft,
                       end: Alignment.bottomRight,
                       colors: [
                         _getLightThemeColor(themeService, opacity: 0.15),
                         _getLightThemeColor(themeService, opacity: 0.05),
                       ],
                     ),
                     borderRadius: BorderRadius.circular(isVerySmallScreen ? 12 : isSmallScreen ? 15 : 20),
                     border: Border.all(
                       color: _getMediumThemeColor(themeService, opacity: 0.3),
                       width: 1.5,
                     ),
                     boxShadow: [
                       BoxShadow(
                         color: Colors.black.withOpacity(0.1),
                         blurRadius: isVerySmallScreen ? 10 : 15,
                         offset: Offset(0, isVerySmallScreen ? 5 : 8),
                       ),
                       BoxShadow(
                         color: Colors.white.withOpacity(0.1),
                         blurRadius: isVerySmallScreen ? 8 : 10,
                         offset: Offset(0, isVerySmallScreen ? -3 : -5),
                       ),
                     ],
                   ),
                  child: Column(
                    children: [
                                             // Barra de búsqueda con efectos
                       Container(
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(isVerySmallScreen ? 10 : isSmallScreen ? 12 : 15),
                           boxShadow: [
                             BoxShadow(
                               color: Colors.black.withOpacity(0.1),
                               blurRadius: isVerySmallScreen ? 8 : 10,
                               offset: Offset(0, isVerySmallScreen ? 3 : 5),
                             ),
                           ],
                         ),
                         child: TextField(
                           decoration: InputDecoration(
                             labelText: isVerySmallScreen ? 'Buscar' : 'Buscar tareas',
                             labelStyle: TextStyle(
                               color: themeService.primaryColor.withOpacity(0.7),
                               fontWeight: FontWeight.w500,
                               fontSize: isVerySmallScreen ? 12 : isSmallScreen ? 14 : 16,
                             ),
                             prefixIcon: Icon(
                               Icons.search,
                               color: themeService.primaryColor.withOpacity(0.6),
                               size: isVerySmallScreen ? 18 : isSmallScreen ? 20 : 24,
                             ),
                             border: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(isVerySmallScreen ? 10 : isSmallScreen ? 12 : 15),
                               borderSide: BorderSide(color: _getMediumThemeColor(themeService, opacity: 0.3)),
                             ),
                             enabledBorder: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(isVerySmallScreen ? 10 : isSmallScreen ? 12 : 15),
                               borderSide: BorderSide(color: _getMediumThemeColor(themeService, opacity: 0.3)),
                             ),
                             focusedBorder: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(isVerySmallScreen ? 10 : isSmallScreen ? 12 : 15),
                               borderSide: BorderSide(color: themeService.primaryColor, width: 2),
                             ),
                             filled: true,
                             fillColor: Colors.white.withOpacity(0.9),
                             contentPadding: EdgeInsets.symmetric(
                               horizontal: isVerySmallScreen ? 12 : isSmallScreen ? 15 : 20, 
                               vertical: isVerySmallScreen ? 10 : isSmallScreen ? 12 : 15
                             ),
                           ),
                           style: TextStyle(
                             color: themeService.primaryColor.withOpacity(0.8),
                             fontSize: isVerySmallScreen ? 12 : isSmallScreen ? 14 : 16,
                           ),
                           onChanged: _onSearchChanged,
                         ),
                       ),
                       
                       SizedBox(height: isVerySmallScreen ? 12 : isSmallScreen ? 15 : 20),
                      
                                             // Filtro por estado con diseño mejorado
                       Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                                                       // Etiqueta del filtro con ícono funcional
                                                         Row(
                               children: [
                                 Icon(
                                   Icons.filter_list,
                                   color: themeService.primaryColor.withOpacity(0.6),
                                   size: isVerySmallScreen ? 18 : isSmallScreen ? 20 : 24,
                                 ),
                                 SizedBox(width: isVerySmallScreen ? 6 : isSmallScreen ? 8 : 10),
                                 Flexible(
                                   child: Text(
                                     isVerySmallScreen ? 'Filtrar estado:' : 'Filtrar por estado:',
                                     style: TextStyle(
                                       color: themeService.primaryColor.withOpacity(0.8),
                                       fontSize: isVerySmallScreen ? 12 : isSmallScreen ? 14 : 16,
                                       fontWeight: FontWeight.w600,
                                     ),
                                     overflow: TextOverflow.ellipsis,
                                   ),
                                 ),
                                 SizedBox(width: isVerySmallScreen ? 6 : isSmallScreen ? 8 : 10),
                                 // Dropdown funcional
                                 PopupMenuButton<TaskStatus?>(
                                   icon: Icon(
                                     Icons.arrow_drop_down,
                                     color: themeService.primaryColor.withOpacity(0.6),
                                     size: isVerySmallScreen ? 20 : isSmallScreen ? 24 : 28,
                                   ),
                                  onSelected: _onFilterChanged,
                                  itemBuilder: (context) => [
                                                                         PopupMenuItem(
                                       value: null,
                                       child: Row(
                                         children: [
                                           Icon(Icons.list, color: Colors.grey, size: isVerySmallScreen ? 14 : isSmallScreen ? 16 : 20),
                                           SizedBox(width: isVerySmallScreen ? 4 : isSmallScreen ? 6 : 8),
                                           Flexible(
                                             child: Text(
                                               isVerySmallScreen ? 'Todas' : 'Mostrar todas',
                                               style: TextStyle(
                                                 fontSize: isVerySmallScreen ? 11 : isSmallScreen ? 13 : 14,
                                                 fontWeight: FontWeight.w500,
                                               ),
                                               overflow: TextOverflow.ellipsis,
                                             ),
                                           ),
                                         ],
                                       ),
                                     ),
                                     ...TaskStatus.values.map((status) => PopupMenuItem(
                                       value: status,
                                       child: Row(
                                         children: [
                                           Icon(
                                             _getStatusIcon(status),
                                             color: _getStatusColor(status, themeService),
                                             size: isVerySmallScreen ? 14 : isSmallScreen ? 16 : 20,
                                           ),
                                           SizedBox(width: isVerySmallScreen ? 4 : isSmallScreen ? 6 : 8),
                                           Flexible(
                                             child: Text(
                                               isVerySmallScreen ? status.displayName : 'Mostrar ${status.displayName.toLowerCase()}',
                                               style: TextStyle(
                                                 fontSize: isVerySmallScreen ? 11 : isSmallScreen ? 13 : 14,
                                                 fontWeight: FontWeight.w500,
                                               ),
                                               overflow: TextOverflow.ellipsis,
                                             ),
                                           ),
                                         ],
                                       ),
                                     )),
                                  ],
                                ),
                              ],
                            ),
                                                         SizedBox(height: isVerySmallScreen ? 6 : isSmallScreen ? 8 : 10),
                             
                             // Estado actual del filtro (visible)
                             if (_filterStatus != null)
                               Container(
                                 margin: EdgeInsets.only(bottom: isVerySmallScreen ? 6 : isSmallScreen ? 8 : 10),
                                 padding: EdgeInsets.symmetric(
                                   horizontal: isVerySmallScreen ? 8 : isSmallScreen ? 12 : 15,
                                   vertical: isVerySmallScreen ? 4 : isSmallScreen ? 6 : 8,
                                 ),
                                 decoration: BoxDecoration(
                                   color: _getStatusColor(_filterStatus!, themeService).withOpacity(0.2),
                                   borderRadius: BorderRadius.circular(isVerySmallScreen ? 8 : isSmallScreen ? 10 : 12),
                                   border: Border.all(
                                     color: _getStatusColor(_filterStatus!, themeService).withOpacity(0.5),
                                     width: 1,
                                   ),
                                 ),
                                 child: Row(
                                   mainAxisSize: MainAxisSize.min,
                                   children: [
                                     Icon(
                                       _getStatusIcon(_filterStatus!),
                                       color: _getStatusColor(_filterStatus!, themeService),
                                       size: isVerySmallScreen ? 14 : isSmallScreen ? 16 : 18,
                                     ),
                                     SizedBox(width: isVerySmallScreen ? 4 : isSmallScreen ? 6 : 8),
                                     Flexible(
                                       child: Text(
                                         isVerySmallScreen ? _filterStatus!.displayName : 'Filtro: ${_filterStatus!.displayName}',
                                         style: TextStyle(
                                           color: _getStatusColor(_filterStatus!, themeService),
                                           fontWeight: FontWeight.w600,
                                           fontSize: isVerySmallScreen ? 10 : isSmallScreen ? 12 : 14,
                                         ),
                                         overflow: TextOverflow.ellipsis,
                                       ),
                                     ),
                                     SizedBox(width: isVerySmallScreen ? 4 : isSmallScreen ? 6 : 8),
                                     GestureDetector(
                                       onTap: () => _onFilterChanged(null),
                                       child: Icon(
                                         Icons.close,
                                         color: _getStatusColor(_filterStatus!, themeService),
                                         size: isVerySmallScreen ? 14 : isSmallScreen ? 16 : 18,
                                       ),
                                     ),
                                   ],
                                 ),
                               ),
                         ],
                       ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  IconData _getStatusIcon(TaskStatus status) {
    switch (status) {
      case TaskStatus.OPEN:
        return Icons.radio_button_unchecked;
      case TaskStatus.IN_PROGRESS:
        return Icons.pending;
      case TaskStatus.DONE:
        return Icons.check_circle;
    }
  }

  Color _getStatusColor(TaskStatus status, ThemeService themeService) {
    switch (status) {
      case TaskStatus.OPEN:
        return Color(0xFFE57373); // Rojo suave
      case TaskStatus.IN_PROGRESS:
        return themeService.accentColor; // Usar color de acento del tema
      case TaskStatus.DONE:
        return Color(0xFF81C784); // Verde suave
    }
  }
}
