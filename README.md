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

## ⚠️ Advertencia sobre Vercel

> **Vercel NO es compatible al 100% con Flutter Web.**
>
> - Puede aparecer pantalla blanca tras el registro o navegación.
> - La navegación automática puede fallar.
> - El usuario debe navegar manualmente al login si no es redirigido.
>
> **Recomendamos usar Netlify, Firebase Hosting o GitHub Pages para producción.**

## Créditos y contacto
- Autor: [Tu Nombre]
- Contacto: [tu.email@dominio.com]
