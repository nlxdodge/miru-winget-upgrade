Write-Host "Updating winget repository for new Miru version..." -ForegroundColor Magenta

# Update manifest
$working_directory = "$home/winget-temp";
$url = Read-host "Latest Miru x64 windows URL (https://...)"
$version = Read-host "Version (x.x.x)"
Write-Host "Creating updated manifest..." -ForegroundColor Magenta
mkdir "$working_directory"
wingetcreate update -u "$url|x64" -v "$version" -o "$working_directory" ThaUnknown.Miru

# PR checks
Write-Host "Synchronize the repository from winget-packages" -ForegroundColor Magenta
Start-Process "https://github.com/nlxdodge/winget-pkgs/"
Write-Host "Press any key to continue" -ForegroundColor Magenta -NoNewline; Read-Host

Write-Host "Check if any other PR is already created before continuing..." -ForegroundColor Magenta
Start-Process "https://github.com/microsoft/winget-pkgs/pulls?q=is%3Apr+is%3Aopen+miru"
Write-Host "Press any key to continue" -ForegroundColor Magenta -NoNewline; Read-Host

Write-Host "Validating manifest..." -ForegroundColor Magenta
winget validate --manifest "$home/winget-temp/manifests/t/ThaUnknown/Miru/$version"

Write-Host "Installing manifest..." -ForegroundColor Magenta
winget install --manifest "$home/winget-temp/manifests/t/ThaUnknown/Miru/$version"
Write-Host "Check if the validation and installation are good for the PR" -ForegroundColor Magenta -NoNewline; Read-Host

# Create PR
wingetcreate submit "$home/winget-temp/manifests/t/ThaUnknown/Miru/$version"

# Clean up
Write-host "Cleaning up..." -ForegroundColor Magenta
rmdir /s /q "$home/winget-temp"
Write-host "Done!" -ForegroundColor Magenta