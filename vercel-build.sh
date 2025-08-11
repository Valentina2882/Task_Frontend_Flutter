#!/bin/bash

echo "🚀 Iniciando build para Vercel..."

# Verificar si Flutter está disponible
if ! command -v flutter &> /dev/null; then
    echo "📦 Instalando Flutter..."
    git clone https://github.com/flutter/flutter.git -b stable
    export PATH="$PATH:`pwd`/flutter/bin"
fi

echo "📋 Obteniendo dependencias..."
flutter pub get

echo "🔨 Compilando para web..."
flutter build web --release

echo "📁 Creando directorio public..."
mkdir -p public

echo "📋 Copiando archivos a public..."
cp -r build/web/* public/

echo "✅ Build completado exitosamente!"
echo "📂 Archivos disponibles en: public/"
ls -la public/
