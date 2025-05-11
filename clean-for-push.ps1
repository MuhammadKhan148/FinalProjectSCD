# Clean repository for GitHub push - removes large files that exceed GitHub's limit
Write-Host "Cleaning repository for GitHub push..."

# Make sure we have the latest changes
git pull origin clean-branch

# Create a new branch for the clean push
$branchName = "github-push-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
git checkout -b $branchName

# Remove the large files
Write-Host "Removing large binary files..."
if (Test-Path temp_binaries) {
    Remove-Item -Path temp_binaries -Recurse -Force
    Write-Host "Removed temp_binaries directory"
}

# Check for other large files (>50MB) and remove them
Write-Host "Checking for other large files..."
$largeFiles = Get-ChildItem -Path . -Recurse -File | Where-Object { $_.Length -gt 50MB }
foreach ($file in $largeFiles) {
    Write-Host "Found large file: $($file.FullName) ($([math]::Round($file.Length / 1MB, 2)) MB)"
    Remove-Item -Path $file.FullName -Force
    Write-Host "Removed $($file.FullName)"
}

# Add all changes
git add .

# Commit the changes
git commit -m "Clean repository for GitHub push - removed large files"

# Push to GitHub
Write-Host "Pushing to GitHub..."
git push -u origin $branchName

Write-Host "Completed! Branch $branchName is ready to be used on GitHub." 