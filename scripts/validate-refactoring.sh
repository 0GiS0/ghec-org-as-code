#!/usr/bin/env bash
set -eo pipefail

# Validation script for the refactored repository
# This script validates the modular structure without template dependencies

echo "🔍 Validando estructura refactorizada..."

# Check if we're in the right directory
if [[ ! -f "main.tf" ]] || [[ ! -d "modules" ]]; then
    echo "❌ Error: Ejecutar desde el directorio raíz del repositorio"
    exit 1
fi

# Terraform formatting
echo "📝 Formateando código Terraform..."
terraform fmt
echo "✅ Formato Terraform aplicado"

# Terraform validation
echo "🔧 Validando configuración Terraform..."
terraform validate
echo "✅ Configuración Terraform válida"

# Python formatting
echo "🐍 Formateando código Python en plantillas..."
./scripts/repo-tools/format-python.sh
echo "✅ Formato Python aplicado"

# Summary
echo ""
echo "📊 Resumen de la estructura refactorizada:"
echo "=========================================="

echo "📁 Módulos creados:"
find modules/ -name "main.tf" | wc -l | xargs echo "   -" 

echo "📄 Archivos principales:"
wc -l main.tf variables.tf outputs.tf custom_properties.tf | grep -v "total"

echo "📈 Archivo más grande anterior: 1852 líneas (repositories.tf)"
echo "📉 Archivo más grande actual:" $(find . -name "*.tf" -not -path "./modules/repository-files/*" -not -name "*legacy*" -exec wc -l {} \; | sort -nr | head -1 | awk '{print $1}') "líneas"

echo ""
echo "🎉 ¡Refactoring completado exitosamente!"
echo ""
echo "⚠️  NOTA: El módulo repository-files está comentado debido a plantillas faltantes."
echo "   Descomenta en main.tf cuando las plantillas estén completas."