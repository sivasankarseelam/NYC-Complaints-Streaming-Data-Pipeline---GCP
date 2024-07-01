# Use the official Python image as base
FROM python:3.9-slim

# Install the Google Cloud SDK
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    && curl -sSL https://sdk.cloud.google.com | bash

# Add Google Cloud SDK binaries to PATH
ENV PATH $PATH:/root/google-cloud-sdk/bin:C:\Users\sivas\AppData\Local\Google\Cloud SDK\bin

# Install any additional dependencies if required
# For example:
# RUN pip install some_package

# Set the working directory
WORKDIR /app

# Copy the cloud_functions.zip file to the container
COPY cloud_functions.zip /app/

# Command to run when the container starts
CMD ["bash"]
