#!/bin/bash
set -e

ZIP_NAME="lambda_function.zip"

# Clean old builds
rm -rf package $ZIP_NAME

# Create dependency directory
mkdir -p package

# Install Python libraries into ./package/
pip3 install pg8000 openpyxl -t package/

# Copy lambda code
cp lambda_function.py package/

# Zip the contents
cd package
zip -r "../$ZIP_NAME" .
cd ..

echo "✅ Build complete: $ZIP_NAME"