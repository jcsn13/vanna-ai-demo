# Use Python 3.10 slim image as base
FROM python:3.10-slim

# Set the working directory
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Set environment variables
EXPOSE 8084

# Command to run the application
CMD exec python app.py