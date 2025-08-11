# 🚀 Despliegue en Vercel - Task Manager Flutter Web

## ⚠️ Importante: Enfoque Pre-compilado

Debido a que Vercel no tiene Flutter pre-instalado, usamos un enfoque de **archivos pre-compilados**.

## 📋 Pasos para Desplegar

### 1. Preparar Archivos Localmente

```bash
# Navegar al directorio del proyecto
cd frontend_tasks

# Instalar dependencias
flutter pub get

# Compilar para web
flutter build web --release

# Preparar archivos para Vercel
chmod +x prepare-for-vercel.sh
./prepare-for-vercel.sh
```

### 2. Verificar Archivos

Después de ejecutar el script, deberías tener:
```
frontend_tasks/
├── public/
│   ├── index.html
│   ├── main.dart.js
│   ├── flutter.js
│   ├── manifest.json
│   └── ... (otros archivos)
```

### 3. Subir a GitHub

```bash
git add .
git commit -m "Preparar archivos para Vercel"
git push origin main
```

### 4. Configurar Vercel

1. Ve a [vercel.com](https://vercel.com)
2. Conecta tu repositorio de GitHub
3. Selecciona la carpeta `frontend_tasks`
4. En la configuración:
   - **Framework Preset**: Other
   - **Build Command**: `echo 'No build needed'`
   - **Output Directory**: `public`
   - **Install Command**: (dejar vacío)

### 5. Desplegar

- Haz clic en **Deploy**
- Vercel usará los archivos pre-compilados en `public/`

## 🔧 Configuración de Archivos

### vercel.json
```json
{
  "buildCommand": "echo 'No build needed'",
  "outputDirectory": "public",
  "rewrites": [
    {
      "source": "/(.*)",
      "destination": "/index.html"
    }
  ]
}
```

### package.json
```json
{
  "scripts": {
    "build": "echo 'Build completed'",
    "vercel-build": "echo 'Vercel build completed'"
  }
}
```

## 🐛 Solución de Problemas

### Error: "No Output Directory named 'public' found"
- Asegúrate de haber ejecutado `./prepare-for-vercel.sh`
- Verifica que el directorio `public/` existe y contiene archivos

### Error: "flutter: command not found"
- Este error es esperado en Vercel
- Los archivos deben estar pre-compilados localmente

### Error: "Build failed"
- Verifica que el directorio `public/` contiene:
  - `index.html`
  - `main.dart.js`
  - `flutter.js`
  - `manifest.json`

## 🔄 Actualizaciones

Para actualizar la aplicación:

1. **Localmente**:
   ```bash
   flutter build web --release
   ./prepare-for-vercel.sh
   git add .
   git commit -m "Actualizar aplicación"
   git push origin main
   ```

2. **En Vercel**:
   - El despliegue se activará automáticamente
   - O haz clic en **Redeploy** manualmente

## ✅ Verificación

Después del despliegue:
- ✅ La aplicación carga correctamente
- ✅ Se conecta al backend en Railway
- ✅ Todas las funcionalidades funcionan
- ✅ Diseño responsive en 320x642+

## 🌐 URLs

- **Frontend**: Tu dominio de Vercel
- **Backend**: `https://taskbackendnestjs-production.up.railway.app`
- **Swagger**: `https://taskbackendnestjs-production.up.railway.app/api`
