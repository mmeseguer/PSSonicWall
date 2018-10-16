###### Begin install script ######
Write-Host 'Running AppVeyor install script' -ForegroundColor Yellow

###### Install packages  ######
# NuGet
Write-Host 'Installing NuGet PackageProvide'
$pkg = Install-PackageProvider -Name NuGet -Force
Write-Host "Installed NuGet version '$($pkg.version)'" 

# Pester
Write-Host 'Installing Pester'
Install-Module -Name Pester -Repository PSGallery -Force

# PSScriptAnalyzer
Write-Host 'Installing PSScriptAnalyzer'
Install-Module PSScriptAnalyzer -Repository PSGallery -force