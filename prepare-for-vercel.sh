#!/bin/bash

echo "🚀 Preparando archivos para Vercel..."

# Verificar si ya existe el directorio public
if [ -d "public" ]; then
    echo "📁 Directorio public ya existe, limpiando..."
    rm -rf public
fi

# Crear directorio public
mkdir -p public

# Verificar si existe build/web
if [ -d "build/web" ]; then
    echo "📋 Copiando archivos de build/web a public..."
    cp -r build/web/* public/
    echo "✅ Archivos copiados exitosamente"
else
    echo "⚠️  Directorio build/web no encontrado"
    echo "📝 Creando archivos de ejemplo..."
    
    # Crear un index.html básico
    cat > public/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <base href="$FLUTTER_BASE_HREF">
    <meta charset="UTF-8">
    <meta content="IE=Edge" http-equiv="X-UA-Compatible">
    <meta name="description" content="Task Manager App">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta name="apple-mobile-web-app-title" content="Task Manager">
    <link rel="apple-touch-icon" href="icons/Icon-192.png">
    <link rel="icon" type="image/png" href="favicon.png"/>
    <title>Task Manager</title>
    <link rel="manifest" href="manifest.json">
    <script>
        var serviceWorkerVersion = null;
    </script>
    <script src="flutter.js" defer></script>
</head>
<body>
    <script>
        window.addEventListener('load', function(ev) {
            _flutter.loader.loadEntrypoint({
                serviceWorker: {
                    serviceWorkerVersion: serviceWorkerVersion,
                },
                onEntrypointLoaded: function(engineInitializer) {
                    engineInitializer.initializeEngine().then(function(appRunner) {
                        appRunner.runApp();
                    });
                }
            });
        });
    </script>
</body>
</html>
EOF

    # Crear un manifest.json básico
    cat > public/manifest.json << 'EOF'
{
    "name": "Task Manager",
    "short_name": "Task Manager",
    "start_url": ".",
    "display": "standalone",
    "background_color": "#0175C2",
    "theme_color": "#0175C2",
    "description": "Aplicación de gestión de tareas",
    "orientation": "portrait-primary",
    "prefer_related_applications": false,
    "icons": [
        {
            "src": "icons/Icon-192.png",
            "sizes": "192x192",
            "type": "image/png"
        },
        {
            "src": "icons/Icon-512.png",
            "sizes": "512x512",
            "type": "image/png"
        }
    ]
}
EOF

    echo "📝 Archivos de ejemplo creados"
fi

echo "📂 Contenido del directorio public:"
ls -la public/

echo "✅ Preparación completada!"
