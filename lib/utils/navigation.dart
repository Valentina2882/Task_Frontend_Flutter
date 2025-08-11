import 'package:flutter/material.dart';

/// Clave global para acceder al Navigator desde cualquier lugar
/// Útil para mostrar SnackBars y diálogos desde StatelessWidgets
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
