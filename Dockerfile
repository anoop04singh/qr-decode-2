# Use an official Python slim image
FROM python:3.9-slim

# Install system dependencies, including libzbar0
RUN apt-get update && \
    apt-get install -y libzbar0 && \
    rm -rf /var/lib/apt/lists/*

# Create a symlink so that pyzbar finds the library at /usr/lib/libzbar.so
RUN ln -s /usr/lib/x86_64-linux-gnu/libzbar.so /usr/lib/libzbar.so

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Expose port 5000 (Vercel will map the correct PORT env variable)
EXPOSE 5000

# Start the Flask app with Gunicorn
CMD ["gunicorn", "api.index:app", "--bind", "0.0.0.0:$PORT"]
