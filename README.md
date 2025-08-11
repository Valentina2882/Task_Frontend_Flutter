# Task Management Frontend (Flutter Web)

Este es el frontend de la aplicación de gestión de tareas, desarrollado con **Flutter Web**.

## Características principales
- Registro y login de usuarios
- Gestión visual de tareas
- Interfaz moderna y responsiva

## Instalación y desarrollo local

1. **Clona el repositorio:**
   ```bash
   git clone <repo-url>
   cd frontend_tasks
   ```

2. **Instala dependencias:**
   ```bash
   flutter pub get
   ```

3. **Corre en local:**
   ```bash
   flutter run -d chrome
   ```

4. **Build para producción:**
   ```bash
   flutter build web
   ```
   El resultado estará en la carpeta `build/web`.

## Deploy recomendado

### Netlify (manual)
1. Ejecuta `flutter build web` en tu máquina local.
2. Sube la carpeta `build/web` al dashboard de Netlify (deploy manual).

### Firebase Hosting
1. Ejecuta `flutter build web`.
2. Usa Firebase CLI para subir la carpeta `build/web`.

### GitHub Pages
1. Ejecuta `flutter build web --base-href /<repo>/`.
2. Sube el contenido de `build/web` a la rama `gh-pages`.

---

## ⚠️ Advertencia sobre Vercel y Flutter Web

> **Este proyecto está desplegado en Vercel.**
>
> - Vercel NO soporta completamente Flutter Web: pueden aparecer pantallas blancas o problemas de navegación automática.
> - Tras registrarte, la app intenta redirigirte automáticamente a `/login`. Si no ocurre, navega manualmente a `/login`.
