#!/bin/bash

# Instalar Flutter si no está disponible
if ! command -v flutter &> /dev/null; then
    echo "Flutter no encontrado, instalando..."
    git clone https://github.com/flutter/flutter.git -b stable
    export PATH="$PATH:`pwd`/flutter/bin"
fi

# Obtener dependencias
flutter pub get

# Compilar para web
flutter build web --release

# Crear directorio public para Vercel
mkdir -p public

# Mover archivos de build/web a public
cp -r build/web/* public/

echo "Build completado exitosamente!"
echo "Archivos copiados a directorio public/"
