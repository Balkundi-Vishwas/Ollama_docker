# Ollama Docker Container with Persistent Model Storage

This repository contains a customized Docker configuration for running Ollama with persistent model storage. The setup allows you to run any of the open Source Large Language Models(LLM) locally while ensuring that downloaded models are preserved even when containers are removed.

## Overview

This project provides:
- A custom Docker image based on the official Ollama image
- An entrypoint script that properly initializes the Ollama server
- Configuration for persistent model storage using Docker volumes
- Automatic download of the `deepseek-r1:1.5b-qwen-distill-q4_K_M` model (or detection if already downloaded)

## Files in this Repository

- `Dockerfile`: Defines the custom Ollama container
- `entrypoint.sh`: Startup script that handles server initialization and model downloading
- `README.md`: This documentation file

## Prerequisites

- Docker installed on your system
- Sufficient disk space for language model storage (varies by model)

## Quick Start

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/ollama-docker.git
   cd ollama-docker
   ```

2. Build the Docker image:
   ```bash
   docker build -t ollama-custom .
   ```

3. Run the container with a volume mount for persistent storage:
   ```bash
   docker run --name ollama-container -p 8080:11434 -v "/path/to/model/storage:/root/.ollama" ollama-custom
   ```

   For Windows users:
   ```bash
   docker run --name ollama-container -p 8080:11434 -v "C:/Users/YourUsername/path/to/storage:/root/.ollama" ollama-custom
   ```

4. Access the Ollama API at `http://localhost:8080`

## How It Works

### Dockerfile

The Dockerfile extends the official Ollama image by:
- Setting up a working directory
- Defining a volume for model persistence
- Copying and configuring the entrypoint script
- Setting the entrypoint command

```dockerfile
# Use the official Ollama image as the base
FROM ollama/ollama

# Set the working directory
WORKDIR /root

# Define a volume for model persistence
VOLUME ["/root/.ollama"]

# Copy the startup script into the container
COPY entrypoint.sh /entrypoint.sh

# Give execution permissions to the script
RUN chmod +x /entrypoint.sh

# Set the startup command
ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]
```

### Entrypoint Script

The entrypoint script handles:
1. Starting the Ollama server in the background
2. Waiting for the server to fully initialize
3. Checking if the specified model is already downloaded
4. Downloading the model if needed
5. Keeping the container running

```bash
#!/bin/bash

echo "Starting Ollama server..."

# Ensure the directory exists
mkdir -p /root/.ollama

# Start the Ollama server in the background
ollama serve &

# Wait for the server to start
echo "Waiting for Ollama server to initialize..."
sleep 10

# Check if model is already downloaded
if ! ollama list | grep -q "deepseek-r1:1.5b-qwen-distill-q4_K_M"; then
    echo "Pulling deepseek-r1:1.5b-qwen-distill-q4_K_M model..."
    ollama pull deepseek-r1:1.5b-qwen-distill-q4_K_M
fi

# Keep the container running
wait
```

## Model Information

This container is configured to download the `deepseek-r1:1.5b-qwen-distill-q4_K_M` model, which is:
- A smaller, quantized language model (1.5B parameters)
- Based on the Qwen architecture
- Optimized for efficiency while maintaining reasonable response quality
- Appropriate for resource-constrained environments

## Customization

### Using Different Models

To use a different model, modify the model name in the `entrypoint.sh` script:

```bash
# Replace "deepseek-r1:1.5b-qwen-distill-q4_K_M" with your preferred model
if ! ollama list | grep -q "your-model-name"; then
    echo "Pulling your-model-name model..."
    ollama pull your-model-name
fi
```

### Port Configuration

The default configuration exposes Ollama on port 8080. To use a different port:

```bash
docker run --name ollama-container -p YOUR_PORT:11434 -v "/path/to/storage:/root/.ollama" ollama-custom
```

## Troubleshooting

### Model Download Issues

If you encounter issues with model downloads:
1. Ensure you have a stable internet connection
2. Check that your volume mount has sufficient space
3. Increase the sleep duration in `entrypoint.sh` to allow more time for server initialization

### Container Not Starting

If the container fails to start:
1. Check Docker logs: `docker logs ollama-container`
2. Ensure the entrypoint.sh has proper line endings (LF, not CRLF)
3. Verify permissions: `chmod +x entrypoint.sh`

### API Connection Issues

If you can't connect to the API:
1. Verify the container is running: `docker ps`
2. Check that the port mapping is correct
3. Try accessing `http://localhost:8080/api/tags` to see available models

## API Usage Examples

Once the container is running, you can interact with the Ollama API:

```bash
# List available models
curl http://localhost:8080/api/tags

# Generate text
curl -X POST http://localhost:8080/api/generate -d '{
  "model": "deepseek-r1:1.5b-qwen-distill-q4_K_M",
  "prompt": "Write a short poem about technology."
}'
```

## License

This project is distributed under the same license as Ollama.

## Acknowledgements

- Based on the official [Ollama](https://github.com/ollama/ollama) project
- DeepSeek model developed by [DeepSeek AI](https://github.com/deepseek-ai)
