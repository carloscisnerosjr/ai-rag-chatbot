#!/bin/bash

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Installing Docker..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # Install Docker Desktop on macOS
        if ! command -v brew &> /dev/null; then
            echo "Homebrew is not installed. Please install Homebrew first and rerun this script."
            exit 1
        fi
        brew install --cask docker
        echo "Starting Docker Desktop..."
        # Launch Docker Desktop and minimize using AppleScript
        open /Applications/Docker.app
        osascript -e 'tell application "Docker" to set miniaturized of every window to true'
        echo "Waiting for Docker daemon to start..."
        while ! docker info &> /dev/null; do
            sleep 2
        done
        echo "Docker is ready."
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Install Docker on Linux
        curl -fsSL https://get.docker.com | sh
        sudo systemctl start docker
        sudo systemctl enable docker
        echo "Docker installed and started."
    else
        echo "Unsupported OS. Please install Docker manually and rerun this script."
        exit 1
    fi
else
    echo "Docker is already installed."
fi

# Install pnpm if not installed
if ! command -v pnpm &> /dev/null; then
    echo "pnpm is not installed. Installing pnpm..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install pnpm
    else
        curl -fsSL https://get.pnpm.io/install.sh | sh -
    fi
else
    echo "pnpm is already installed."
fi

# Install dependencies
echo "Installing dependencies with pnpm..."
pnpm install
pnpm add @vercel/postgres openai drizzle-orm ai

# Setup database
echo "Setting up the database with Docker..."
docker pull supabase/postgres:15.6.1.143
docker compose up -d

# Run migrations
echo "Running database migrations..."
pnpm db:migrate
pnpm db:push
