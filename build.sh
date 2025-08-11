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

# Mover archivos a la carpeta correcta para Vercel
cp -r build/web/* .

echo "Build completado exitosamente!"
