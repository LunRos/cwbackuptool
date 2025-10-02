# Counterwatch Data Backup & Restore Script
#
# This script provides a menu to:
# 1. Backup: Finds the specific IndexedDB folder, stops Overwolf, and compresses the folder into a .zip file on your Desktop.
# 2. Restore: Stops Overwolf, asks for a backup .zip file, deletes the current IndexedDB folder, and extracts the backup in its place.
#MIT License
#
# Copyright (c) 2025 Luna Rose
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# --- Configuration ---
# Construct the path to the IndexedDB folder using the %localappdata% environment variable.
$dbFolderName = "overwolf-extension_jibicdemenmbbgklpbgioihcacpgefpphlffhanp_0.indexeddb.leveldb"
$dbPath = Join-Path $env:LOCALAPPDATA "Overwolf\CefBrowserCache\Default\IndexedDB\$dbFolderName"

# --- Functions ---

# Function to stop the Overwolf process
function Stop-OverwolfProcess {
    Write-Host "Checking for Overwolf process..." -ForegroundColor Yellow
    $overwolfProcess = Get-Process -Name "Overwolf" -ErrorAction SilentlyContinue
    if ($overwolfProcess) {
        Write-Host "Overwolf is running. Attempting to close it now." -ForegroundColor Green
        Stop-Process -Name "Overwolf" -Force
        # Wait a few seconds to ensure the process has fully terminated and released file locks
        Start-Sleep -Seconds 5
        Write-Host "Overwolf process stopped." -ForegroundColor Green
    } else {
        Write-Host "Overwolf is not currently running." -ForegroundColor Gray
    }
}

# Function to handle the backup process
function Create-Backup {
    Write-Host "`n----- Starting Backup Process -----" -ForegroundColor Cyan

    Stop-OverwolfProcess

    if (-not (Test-Path -Path $dbPath)) {
        Write-Host "Error: Database directory not found at '$dbPath'" -ForegroundColor Red
        Write-Host "Please ensure Overwolf and Counterwatch have been run at least once." -ForegroundColor Red
        return
    }

    Write-Host "Database directory found." -ForegroundColor Green

    # Define the backup file name and path (saved to the user's Desktop)
    $desktopPath = [Environment]::GetFolderPath('Desktop')
    $backupFileName = "Counterwatch_Backup_$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss').zip"
    $destinationZipPath = Join-Path $desktopPath $backupFileName

    Write-Host "Creating backup archive at '$destinationZipPath'..." -ForegroundColor Yellow

    try {
        Compress-Archive -Path $dbPath -DestinationPath $destinationZipPath -Force
        Write-Host "SUCCESS: Backup completed successfully!" -ForegroundColor Green
        Write-Host "Your backup file is located on your Desktop: $backupFileName" -ForegroundColor Green
    } catch {
        Write-Host "ERROR: Failed to create the backup archive." -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
    }
}

# Function to handle the restore process
function Restore-FromBackup {
    Write-Host "`n----- Starting Restore Process -----" -ForegroundColor Cyan

    # Get the path to the backup file from the user
    $backupZipPath = Read-Host -Prompt "Please enter the full path to your backup .zip file (or drag and drop it here and press Enter)"
    
    # Clean up the path if it's wrapped in quotes (happens with drag-and-drop)
    $backupZipPath = $backupZipPath.Trim('"')

    if (-not (Test-Path -Path $backupZipPath -PathType Leaf) -or ($backupZipPath -notlike "*.zip")) {
        Write-Host "Error: The path provided is not a valid .zip file. Please try again." -ForegroundColor Red
        return
    }

    Write-Host "Backup file found: $backupZipPath" -ForegroundColor Green

    Stop-OverwolfProcess

    # Delete the existing directory if it exists
    if (Test-Path -Path $dbPath) {
        Write-Host "Removing existing database directory..." -ForegroundColor Yellow
        try {
            Remove-Item -Path $dbPath -Recurse -Force
            Write-Host "Existing directory removed." -ForegroundColor Green
        } catch {
            Write-Host "ERROR: Could not remove the existing directory at '$dbPath'." -ForegroundColor Red
            Write-Host $_.Exception.Message -ForegroundColor Red
            return
        }
    }

    # Extract the backup
    Write-Host "Extracting backup to the original location..." -ForegroundColor Yellow
    $destinationFolder = Join-Path $env:LOCALAPPDATA "Overwolf\CefBrowserCache\Default\IndexedDB"
    
    try {
        Expand-Archive -Path $backupZipPath -DestinationPath $destinationFolder -Force
        Write-Host "SUCCESS: Restore completed successfully!" -ForegroundColor Green
        Write-Host "You can now start Overwolf." -ForegroundColor Green
    } catch {
        Write-Host "ERROR: Failed to extract the archive." -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
    }
}

# --- Main Menu ---
while ($true) {
    Write-Host "`n=================================================" -ForegroundColor White
    Write-Host "  Overwolf Counterwatch Backup & Restore Tool"
    Write-Host "=================================================" -ForegroundColor White
    Write-Host "Please choose an option:" -ForegroundColor White
    Write-Host " 1: [Backup] Create a backup of your Counterwatch data" -ForegroundColor Cyan
    Write-Host " 2: [Restore] Restore your Counterwatch data from a backup" -ForegroundColor Yellow
    Write-Host " 3: [Exit] Close this script" -ForegroundColor Gray
    $choice = Read-Host -Prompt "Enter your choice (1, 2, or 3)"

    switch ($choice) {
        "1" {
            Create-Backup
        }
        "2" {
            Restore-FromBackup
        }
        "3" {
            Write-Host "Exiting." -ForegroundColor Gray
            return
        }
        default {
            Write-Host "Invalid choice. Please enter 1, 2, or 3." -ForegroundColor Red
        }
    }
    
    Write-Host "`nPress any key to return to the menu..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    Clear-Host
}



