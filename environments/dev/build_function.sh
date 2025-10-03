#!/bin/bash
set -e

ZIP_NAME="lambda_function.zip"

# Clean old builds
rm -rf package $ZIP_NAME

# Create folder for function code
mkdir -p package

# Copy lambda code
cp lambda_function.py package/

# Zip the function
cd package
zip -r "../$ZIP_NAME" .
cd ..

echo "✅ Lambda function zip created: $ZIP_NAME"