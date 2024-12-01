# Check if Docker is installed
if (-not (Get-Command "docker")) {
    Write-Host "Docker is not installed. Installing Docker Desktop..."

    # Download Docker Desktop Installer
    $installerUrl = "https://desktop.docker.com/win/stable/Docker Desktop Installer.exe"
    $installerPath = "$env:TEMP\DockerDesktopInstaller.exe"
    Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath

    # Install Docker Desktop silently
    Start-Process -FilePath $installerPath -ArgumentList "--quiet" -Wait

    Write-Host "Docker Desktop installed. Please ensure it's set to start at login for future use."
} else {
    Write-Host "Docker is already installed."
}

# Start Docker Desktop
Write-Host "Starting Docker Desktop..."
Start-Process -FilePath "C:\Program Files\Docker\Docker\Docker Desktop.exe"

# Wait for Docker to initialize
Write-Host "Waiting for Docker to initialize..."
while ($true) {
    try {
        docker info | Out-Null
        Write-Host "Docker is ready."
        break
    } catch {
        Write-Host "Docker is not ready. Retrying in 2 seconds..."
        Start-Sleep -Seconds 2
    }
}

# Install pnpm if not installed
if (-not (Get-Command "pnpm")) {
    Write-Host "pnpm is not installed. Installing pnpm..."
    try {
        Invoke-Expression (iwr -useb https://get.pnpm.io/install.ps1 | iex)
        Write-Host "pnpm installed successfully."
    } catch {
        Write-Host "Failed to install pnpm. Please check your internet connection or manually install pnpm."
        exit 1
    }
} else {
    Write-Host "pnpm is already installed."
}

# Install dependencies
Write-Host "Installing dependencies with pnpm..."
pnpm install
if ($LASTEXITCODE -ne 0) {
    Write-Host "Failed to install dependencies with pnpm. Please check your setup and try again."
    exit 1
}

pnpm add @vercel/postgres openai drizzle-orm ai
if ($LASTEXITCODE -ne 0) {
    Write-Host "Failed to add required packages with pnpm. Please check your setup and try again."
    exit 1
}

Write-Host "Dependencies installed successfully."

# Setup database
Write-Host "Setting up the database with Docker..."
docker pull supabase/postgres:15.6.1.143
docker compose up -d

# Run migrations
Write-Host "Running database migrations..."
pnpm db:migrate
if ($LASTEXITCODE -ne 0) {
    Write-Host "Failed to run database migrations. Please check your configuration and try again."
    exit 1
}

pnpm db:push
if ($LASTEXITCODE -ne 0) {
    Write-Host "Failed to push database changes. Please check your configuration and try again."
    exit 1
}

# Start the development server in the background
Write-Host "Starting the development server in the background..."
Start-Process -FilePath "pnpm" -ArgumentList "run dev" -NoNewWindow 
Write-Host "Development server started in the background. Server is now running at http://localhost:3000."

# Start the database studio in the background
Write-Host "Starting the database studio in the background..."
Start-Process -FilePath "pnpm" -ArgumentList "db:studio" -NoNewWindow 
Write-Host "Database studio started in the background. Database studio is now running at https://local.drizzle.studio." 
