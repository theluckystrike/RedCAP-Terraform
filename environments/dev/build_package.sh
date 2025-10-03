#!/bin/bash
set -e

LAYER_NAME="redcap_deps_layer"
ZIP_NAME="redcap_layer.zip"

# Clean old builds
rm -rf python $ZIP_NAME
mkdir -p python

# Install dependencies in a clean Linux Docker environment
docker run --rm -v "$PWD":/var/task lambci/lambda:build-python3.11 bash -c "
    pip install numpy pandas pg8000 psycopg2-binary boto3 -t /var/task/python
    cd python
    # Strip unnecessary files to reduce size
    find . -name '*.dist-info' -type d -exec rm -rf {} +
    find . -name 'tests' -type d -exec rm -rf {} +
    find . -name '*.so' -exec strip {} + || true
"

# Zip the layer
zip -r $ZIP_NAME python

echo "✅ Layer zip created: $ZIP_NAME (Linux build, smaller size)"