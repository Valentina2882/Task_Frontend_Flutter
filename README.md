# Task Management App - Frontend Flutter

Aplicación móvil desarrollada en Flutter para la gestión de tareas, conectada con un backend NestJS.

## 📁 Estructura del Proyecto

```
frontend_tasks/
├── lib/
│   ├── main.dart                 # Punto de entrada de la aplicación
│   ├── models/                   # Modelos de datos
│   │   ├── user.dart            # Modelo de usuario
│   │   └── task.dart            # Modelo de tarea
│   ├── screens/                  # Pantallas de la aplicación
│   │   ├── login_screen.dart    # Pantalla de login con validaciones
│   │   ├── register_screen.dart # Pantalla de registro con validaciones
│   │   └── home_screen.dart     # Pantalla principal con CRUD de tareas
│   ├── services/                 # Servicios para comunicación con el backend
│   │   ├── auth_service.dart    # Servicio de autenticación JWT
│   │   └── task_service.dart    # Servicio completo de gestión de tareas
│   ├── utils/                    # Utilidades globales
│   │   └── navigation.dart      # NavigatorKey global
│   └── widgets/                  # Widgets reutilizables
│       ├── app_header.dart      # Header reutilizable
│       ├── login_form.dart      # Formulario de login
│       ├── register_form.dart   # Formulario de registro
│       ├── task_filters.dart    # Filtros de tareas
│       ├── task_list.dart       # Lista de tareas
│       ├── task_item.dart       # Item individual de tarea
│       ├── empty_tasks.dart     # Estado vacío
│       └── create_task_dialog.dart # Diálogo de creación
├── pubspec.yaml                  # Dependencias configuradas
└── README.md                     # Documentación completa
```

## 🚀 Características

### Autenticación
- **Login**: Inicio de sesión con username y password
- **Registro**: Creación de nuevas cuentas de usuario
- **Validación**: Verificación de credenciales según los requisitos del backend
- **Gestión de tokens**: Manejo automático del token JWT

### Gestión de Tareas
- **Lista de tareas**: Visualización de todas las tareas del usuario
- **Crear tareas**: Formulario para crear nuevas tareas
- **Actualizar estado**: Cambio de estado (Abierta, En Progreso, Completada)
- **Eliminar tareas**: Eliminación con confirmación
- **Filtros**: Filtrado por estado de tarea
- **Búsqueda**: Búsqueda por título y descripción

### Interfaz de Usuario
- **Material Design**: Interfaz moderna y responsive
- **Navegación**: Rutas entre pantallas
- **Feedback visual**: Indicadores de carga y mensajes de estado
- **Validación**: Validación de formularios en tiempo real

## 🛠️ Configuración

### Prerrequisitos
- Flutter SDK (versión 3.0.0 o superior)
- Dart SDK
- Android Studio / VS Code
- Backend NestJS ejecutándose

### Instalación

1. **Clonar el proyecto**:
   ```bash
   git clone <url-del-repositorio>
   cd frontend_tasks
   ```

2. **Instalar dependencias**:
   ```bash
   flutter pub get
   ```

3. **Configurar el backend**:
   - Asegúrate de que el backend NestJS esté ejecutándose en `http://localhost:3000`
   - La aplicación está configurada por defecto para usar `localhost`

### 🌐 Configuración de URLs por Entorno

La aplicación está configurada para diferentes entornos de desarrollo:

#### **Configuración Actual (Localhost)**
```dart
static const String baseUrl = 'http://localhost:3000';
```
- **Funciona para**: Web, iOS Simulator, y algunos emuladores de Android
- **Configuración por defecto** de la aplicación

#### **Para Emulador de Android Studio (si es necesario)**
```dart
static const String baseUrl = 'http://10.0.2.2:3000';
```
- **10.0.2.2** es la IP especial que apunta al localhost del host desde el emulador de Android

#### **Para Dispositivo Físico Android**
```dart
static const String baseUrl = 'http://192.168.1.X:3000';
```
- Reemplaza `192.168.1.X` con la IP de tu computadora en la red local

### Cambiar URL del Backend

Edita los archivos de servicios según tu entorno:
- `lib/services/auth_service.dart`
- `lib/services/task_service.dart`

Cambia la constante `baseUrl` según corresponda.

4. **Ejecutar la aplicación**:
   ```bash
   flutter run
   ```

## 📱 Uso de la Aplicación

### 1. Registro/Login
- Al abrir la aplicación, verás la pantalla de login
- Si no tienes cuenta, toca "Regístrate aquí"
- Completa el formulario de registro con:
  - Username (mínimo 4 caracteres)
  - Password (mínimo 3 caracteres, con mayúsculas, minúsculas y números)

### 2. Gestión de Tareas
- **Ver tareas**: La pantalla principal muestra todas tus tareas
- **Crear tarea**: Toca el botón "+" flotante
- **Cambiar estado**: Toca los 3 puntos en una tarea y selecciona el nuevo estado
- **Eliminar tarea**: Toca los 3 puntos y selecciona "Eliminar"
- **Filtrar**: Usa el dropdown para filtrar por estado
- **Buscar**: Usa la barra de búsqueda para encontrar tareas específicas

### 3. Cerrar Sesión
- Toca el icono de logout en la barra superior

## 🔧 Configuración Avanzada

### Agregar Persistencia de Token
Para mantener la sesión activa entre reinicios, puedes implementar `shared_preferences`:

```dart
// En auth_service.dart
import 'package:shared_preferences/shared_preferences.dart';

// Guardar token
await SharedPreferences.getInstance().then((prefs) {
  prefs.setString('access_token', _accessToken!);
});

// Cargar token al iniciar
await SharedPreferences.getInstance().then((prefs) {
  _accessToken = prefs.getString('access_token');
});
```

### Configuración para Producción
Para producción, cambia las URLs a tu servidor:
```dart
static const String baseUrl = 'https://tu-servidor.com';
```

## 🐛 Solución de Problemas

### Error de Conexión
- Verifica que el backend esté ejecutándose en `http://localhost:3000`
- Comprueba que la URL en los servicios sea correcta según tu entorno
- Revisa la configuración de red
- Para emulador Android: si localhost no funciona, cambia a `10.0.2.2:3000`
- Para dispositivo físico: usa la IP de tu computadora

### Error de Autenticación
- Verifica las credenciales
- Asegúrate de que el usuario exista en el backend
- Comprueba que el token se esté enviando correctamente

### Error de Validación
- Revisa que los campos cumplan con los requisitos mínimos
- Verifica que la contraseña tenga el formato correcto

## 📚 Dependencias Principales

- **provider**: Gestión de estado
- **http**: Peticiones HTTP al backend
- **shared_preferences**: Almacenamiento local (opcional)
- **form_validator**: Validación de formularios

## 🤝 Contribución

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para detalles.

# Task Manager Flutter Web

Aplicación de gestión de tareas construida con Flutter Web.

## 🚀 Despliegue en Vercel

### Pasos para desplegar:

1. **Preparar el proyecto**:
   ```bash
   # Asegúrate de estar en la carpeta frontend_tasks
   cd frontend_tasks
   
   # Obtener dependencias
   flutter pub get
   
   # Compilar para web
   flutter build web --release
   ```

2. **Conectar con Vercel**:
   - Ve a [vercel.com](https://vercel.com)
   - Conecta tu repositorio de GitHub
   - Selecciona la carpeta `frontend_tasks`
   - Vercel detectará automáticamente la configuración

3. **Configuración automática**:
   - Vercel usará el `package.json` y `vercel.json` incluidos
   - El script de build se ejecutará automáticamente
   - La aplicación estará disponible en tu dominio de Vercel

### 📁 Archivos de configuración:

- `vercel.json`: Configuración de rutas y headers
- `package.json`: Scripts de build para Vercel
- `build.sh`: Script de compilación de Flutter

### 🔗 Backend:

La aplicación está configurada para consumir el backend en:
`https://taskbackendnestjs-production.up.railway.app`

### 🌐 URLs de desarrollo:

- **Frontend local**: `http://localhost:3000`
- **Backend**: `https://taskbackendnestjs-production.up.railway.app`

### 📱 Características:

- ✅ Diseño responsive (320x642+)
- ✅ Temas personalizables
- ✅ Filtros y búsqueda
- ✅ Gestión completa de tareas
- ✅ Autenticación JWT
- ✅ Animaciones suaves

### 🛠️ Tecnologías:

- **Frontend**: Flutter Web
- **Backend**: NestJS (Railway)
- **Estado**: Provider
- **Despliegue**: Vercel
