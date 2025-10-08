# Run Amazon Linux container
docker run -it --rm -v "$PWD":/var/task amazonlinux:2023 bash

# Inside the container:
yum install -y python3.11 python3.11-pip zip gcc gcc-c++ make postgresql-devel

# Create the correct layer structure
mkdir -p /var/task/python

# Install packages directly into the python folder
pip3.11 install psycopg2-binary openpyxl -t /var/task/python

# Remove unnecessary files to reduce size
cd /var/task/python
find . -type d -name "tests" -exec rm -rf {} +
find . -type d -name "__pycache__" -exec rm -rf {} +
find . -name "*.pyc" -delete
find . -name "*.so" -exec strip {} \; 2>/dev/null || true

# Zip the layer from the correct location
cd /var/task
zip -r9 lambda_layer.zip python

# Exit container
exit