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
