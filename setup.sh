#!/bin/bash

print_separator() {
    echo -e "\n----------------------------------------"
    echo "🚀 $1"
    echo -e "----------------------------------------\n"
    sleep 1
}

# Check Docker and Colima
print_separator "Checking Docker Installation"
if ! command -v docker &> /dev/null; then
    echo "Installing Docker CLI..."
    brew install docker
fi

print_separator "Checking Colima Installation"
if ! command -v colima &> /dev/null; then
    echo "Installing Colima..."
    brew install colima
fi

print_separator "Starting Docker Runtime"
if ! colima status &> /dev/null; then
    echo "Starting Colima..."
    colima start
    echo "Waiting for Docker daemon to start..."
    while ! docker info &> /dev/null; do
        sleep 2
    done
    echo "Docker is ready!"
fi

print_separator "Setting Up Database"
docker pull supabase/postgres:15.6.1.143
docker-compose up --detach
sleep 3

print_separator "Running Database Migrations"
pnpm db:migrate
pnpm db:push
sleep 2

print_separator "Starting Development Server"
nohup pnpm run dev > server.log 2>&1 &
sleep 3

print_separator "Starting Database Studio"
nohup pnpm db:studio > dbstudio.log 2>&1 &
sleep 3

print_separator "🎉 Setup Complete!"
echo "Access your services at:"
echo "- Server: http://localhost:3000"
echo "- Database Studio: https://local.drizzle.studio"
sleep 1

echo -e "\nView logs with:"
echo "- Server logs: tail -f server.log"
echo "- DB Studio logs: tail -f dbstudio.log"
sleep 1

echo -e "\nTo stop services later:"
echo "pkill -f 'pnpm run dev'"
echo "pkill -f 'pnpm db:studio'"
echo -e "----------------------------------------\n"