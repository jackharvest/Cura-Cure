###############################################################################
#Cura Cure#
###################################################################################################
#Description: Removes the "Machine Disallowed Areas" Restriction from All Printer Profiles in Cura.
#Especially helpful in instances where your bed size has changed from the original printer size,
#such as the use of an Ender Extender, or similar.
###################################################################################################

# Find all installed versions of Ultimaker Cura in the C:\Program Files folder
$curaFolders = Get-ChildItem "C:\Program Files" -Directory | Where-Object { $_.Name -match "^Ultimaker Cura \d+\.\d+\.\d+$" }
if (!$curaFolders) {
    Write-Error "Could not find Ultimaker Cura installation folder"
    exit
}

# Prompt the user to select which version to target if multiple versions are found
if ($curaFolders.Count -gt 1) {
    Write-Host "Multiple versions of Ultimaker Cura detected:"
    $i = 1
    $curaFolders | ForEach-Object {
        Write-Host "$i. $($_.Name)"
        $i++
    }
    $selectedVersion = Read-Host "Enter the number of the version you want to target"
    $curaFolder = $curaFolders[$selectedVersion - 1]
} else {
    $curaFolder = $curaFolders[0]
}

# Set the path to the definitions folder and the backup folder
$folderPath = Join-Path $curaFolder.FullName "share\cura\resources\definitions"
$backupFolderPath = Join-Path $folderPath "machine_disallowed_areas_backup"

# Create the backup folder if it doesn't exist
if (!(Test-Path $backupFolderPath)) {
    New-Item -ItemType Directory -Force -Path $backupFolderPath
}

# Create an empty list to keep track of the modified files
$modifiedFiles = New-Object System.Collections.Generic.List[string]

# Iterate over all JSON files in the definitions folder
Get-ChildItem $folderPath -Filter *.json | ForEach-Object {
    $filePath = $_.FullName
    $fileName = $_.Name
    $backupFilePath = Join-Path $backupFolderPath $fileName

    # Check if a backup file already exists and skip creating a new backup if it does
    if (Test-Path $backupFilePath) {
        Write-Host "$fileName backup already exists, skipping so you have the oldest available version"
    } else {
        try {
            # Create a backup of the original file
            Copy-Item $filePath $backupFilePath -Force
        } catch {
            # Display a warning message if the file is in use and cannot be copied
            Write-Warning "File '$fileName' is in use. Please close Cura and run the script again."
        }
    }

    try {
        # Read the content of the original file
        $originalContent = Get-Content $filePath -Raw

        # Replace the machine_disallowed_areas object with an empty object using a regular expression
        $modifiedContent = $originalContent -replace '(?s)"machine_disallowed_areas"\s*:\s*{\s*"default_value"\s*:\s*\[.*?\]\s*}', '"machine_disallowed_areas": {}'

        # Check if the content was modified and update the file if it was
        if ($originalContent -ne $modifiedContent) {
            # Add the file name to the list of modified files
            $modifiedFiles.Add($fileName)

            # Write the modified content back to the file
            Set-Content $filePath -Value $modifiedContent
        }
    } catch {
        # Display a warning message if the file is in use and cannot be modified
        Write-Warning "File '$fileName' is in use. Please close Cura and run the script again."
    }
}

# Output the names of the modified files
Write-Host "Modified files:"
$modifiedFiles | ForEach-Object { Write-Host $_ }

# Pause at the end and wait for user input before exiting
Write-Host "Press Enter to continue..."
$null = Read-Host