# Task Management Frontend (Flutter Web)

Aplicación de gestión de tareas desarrollada con **Flutter Web** que consume una API REST de NestJS.

## 🏗️ Arquitectura del Proyecto

### Estructura de Carpetas
```
lib/
├── main.dart                 # Punto de entrada de la aplicación
├── models/                   # Modelos de datos
│   ├── user.dart            # Modelo de usuario
│   └── task.dart            # Modelo de tarea con enum TaskStatus
├── screens/                  # Pantallas principales
│   ├── login_screen.dart    # Pantalla de autenticación
│   ├── register_screen.dart # Pantalla de registro
│   └── home_screen.dart     # Pantalla principal de tareas
├── services/                 # Servicios de negocio
│   ├── auth_service.dart    # Autenticación y gestión de tokens JWT
│   ├── task_service.dart    # CRUD de tareas
│   └── theme_service.dart   # Gestión de temas dinámicos
├── widgets/                  # Componentes reutilizables
│   ├── gradient_background.dart # Fondo animado con gradientes
│   ├── app_header.dart      # Header animado
│   ├── login_form.dart      # Formulario de login
│   ├── register_form.dart   # Formulario de registro
│   ├── task_filters.dart    # Filtros y búsqueda de tareas
│   ├── task_list.dart       # Lista de tareas
│   ├── task_item.dart       # Item individual de tarea
│   ├── empty_tasks.dart     # Estado vacío animado
│   └── create_task_dialog.dart # Diálogo de creación
└── utils/                   # Utilidades
    └── navigation.dart      # Clave global de navegación
```

## 🛠️ Tecnologías y Dependencias

### Core
- **Flutter 3.32.8** - Framework de UI
- **Dart 3.8.1** - Lenguaje de programación

### State Management
- **Provider 6.1.5** - Gestión de estado con ChangeNotifier

### HTTP y Networking
- **http 1.5.0** - Cliente HTTP para API REST
- **CORS** configurado en backend para dominios permitidos

### UI/UX
- **Material Design 3** - Sistema de diseño
- **Gradientes animados** - Fondos dinámicos con TickerProviderStateMixin
- **Responsive Design** - Breakpoints: 320px, 400px, desktop
- **Temas dinámicos** - 5 paletas de colores (Morado, Azul, Verde, Naranja, Rosa)

## 🎨 Características de UI/UX

### Diseño Responsivo
```dart
// Breakpoints implementados
final isSmallScreen = screenSize.width < 400;
final isVerySmallScreen = screenSize.width <= 320;
```

### Animaciones
- **GradientBackground**: Partículas animadas con CustomPainter
- **AppHeader**: Animaciones de escala, rotación y deslizamiento
- **TaskFilters**: Transiciones suaves con AnimatedBuilder
- **EmptyTasks**: Animaciones de entrada con múltiples controllers

### Temas Dinámicos
```dart
// 5 paletas de colores predefinidas
final themes = [
  {'name': 'Morado', 'primary': Color(0xFF4A148C), ...},
  {'name': 'Azul', 'primary': Color(0xFF1565C0), ...},
  // ... más temas
];
```

## 🔐 Autenticación

### JWT Token Management
- **AuthService**: Gestión completa de tokens JWT
- **Headers automáticos**: `Authorization: Bearer <token>`
- **Persistencia**: Tokens almacenados en memoria durante sesión

### Endpoints Consumidos
```dart
// Base URL configurada
static const String baseUrl = 'https://taskbackendnestjs-production.up.railway.app';

// Endpoints
POST /auth/signup    // Registro de usuarios
POST /auth/signin    // Login de usuarios
```

## 📋 Gestión de Tareas

### Modelo de Datos
```dart
enum TaskStatus {
  OPEN,           // Abierta
  IN_PROGRESS,    // En Progreso
  DONE           // Completada
}
```

### Operaciones CRUD
- **GET /tasks** - Obtener tareas con filtros opcionales
- **POST /tasks** - Crear nueva tarea
- **PATCH /tasks/{id}/status** - Actualizar estado
- **DELETE /tasks/{id}** - Eliminar tarea

### Filtros y Búsqueda
- **Por estado**: OPEN, IN_PROGRESS, DONE
- **Por texto**: Búsqueda en título y descripción
- **Combinados**: Filtros + búsqueda simultánea

## 🚀 Desarrollo Local

### Prerrequisitos
```bash
flutter --version  # Flutter 3.32.8+
dart --version     # Dart 3.8.1+
```

### Instalación
```bash
git clone <repo-url>
cd frontend_tasks
flutter pub get
```

### Ejecución
```bash
# Desarrollo
flutter run -d chrome

# Build de producción
flutter build web --release
```

### Variables de Entorno
```dart
// Configurar URL del backend en services/
static const String baseUrl = 'http://localhost:3000'; // Desarrollo
static const String baseUrl = 'https://taskbackendnestjs-production.up.railway.app'; // Producción
```

## 📱 Compatibilidad

### Navegadores Soportados
- **Chrome 90+** (recomendado)
- **Firefox 88+**
- **Safari 14+**
- **Edge 90+**

### Tamaños de Pantalla
- **Móvil**: 320px - 480px
- **Tablet**: 481px - 768px
- **Desktop**: 769px+

## 🔧 Configuración de Build

### Web Build
```bash
flutter build web --release --web-renderer canvaskit
```

### Optimizaciones
- **Tree shaking** automático
- **Code splitting** por rutas
- **Asset optimization** con Flutter Web

## 📊 Métricas de Rendimiento

### Bundle Size
- **main.dart.js**: ~2.4MB (gzipped: ~600KB)
- **Canvaskit**: ~1.2MB
- **Total**: ~3.6MB inicial

### Tiempo de Carga
- **First Paint**: ~2-3s
- **Interactive**: ~4-5s
- **Fully Loaded**: ~6-8s

## 🐛 Debugging

### Console Logs
```dart
// Logs implementados en servicios
print('🔐 Login attempt to: $url');
print('📥 Response status: ${response.statusCode}');
print('📥 Response body: ${response.body}');
```

### DevTools
- **Flutter Inspector** para debugging de widgets
- **Network tab** para debugging de API calls
- **Console** para logs de servicios

## 📚 Recursos Adicionales

- [Flutter Web Documentation](https://flutter.dev/web)
- [Provider Package](https://pub.dev/packages/provider)
- [HTTP Package](https://pub.dev/packages/http)
- [Material Design 3](https://m3.material.io/)
