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