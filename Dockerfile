# Use an official Python slim image
FROM python:3.9-slim

# Install system dependencies, including libzbar0
RUN apt-get update && \
    apt-get install -y libzbar0 && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy the requirements file and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of your application code (assumed to be in the api folder)
COPY api/ ./api/

# Expose the port (Vercel will pass the PORT env variable)
EXPOSE 5000

# Start the Flask app with Gunicorn, pointing to the app callable in api/index.py
CMD ["gunicorn", "api.index:app", "--bind", "0.0.0.0:$PORT"]
