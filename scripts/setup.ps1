# Check if Docker is installed
if (-not (Get-Command "docker" -ErrorAction SilentlyContinue)) {
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
$dockerProcess = Start-Process -FilePath "C:\Program Files\Docker\Docker\Docker Desktop.exe" -PassThru

# Minimize Docker Desktop window
Write-Host "Minimizing Docker Desktop window..."
Start-Sleep -Seconds 2  # Give the application a moment to launch
Add-Type -AssemblyName System.Windows.Forms
Add-Type @"
    using System;
    using System.Runtime.InteropServices;
    public class ShowWindow {
        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
    }
"@
$SW_MINIMIZE = 6

$windows = Get-Process | Where-Object { $_.MainWindowTitle -match "Docker Desktop" }
foreach ($window in $windows) {
    [ShowWindow]::ShowWindow($window.MainWindowHandle, $SW_MINIMIZE)
}

# Wait for Docker to initialize
Write-Host "Waiting for Docker to initialize..."
while (-not (docker info -ErrorAction SilentlyContinue)) {
    Start-Sleep -Seconds 2
}
Write-Host "Docker is ready."

# Install pnpm if not installed
if (-not (Get-Command "pnpm" -ErrorAction SilentlyContinue)) {
    Write-Host "Installing pnpm..."
    Invoke-Expression (iwr -useb https://get.pnpm.io/install.ps1 | iex)
} else {
    Write-Host "pnpm is already installed."
}

# Install dependencies
Write-Host "Installing dependencies with pnpm..."
pnpm install
pnpm add @vercel/postgres openai drizzle-orm ai

# Setup database
Write-Host "Setting up the database with Docker..."
docker pull supabase/postgres:15.6.1.143
docker compose up -d

# Run migrations
Write-Host "Running database migrations..."
pnpm db:migrate
pnpm db:push
