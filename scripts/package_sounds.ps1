# PowerShell script to copy sound assets into Android res/raw and iOS Runner bundle
# Usage: .\package_sounds.ps1
# This script copies all files from assets/sounds to:
#  - android/app/src/main/res/raw/ (creates it if missing) with resource-safe lowercase names
#  - ios/Runner/ (creates it if missing) keeping original filenames
# It prints a mapping you can paste into your Dart code for androidRawName and iosFileName.

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
# project root is the parent of the scripts directory
$projectRoot = Split-Path -Parent $scriptDir
$srcDir = Join-Path $projectRoot "assets\sounds"
$androidResDir = Join-Path $projectRoot "android\app\src\main\res\raw"
$iosTargetDir = Join-Path $projectRoot "ios\Runner"

if (-not (Test-Path $srcDir)) {
    Write-Error "Source directory not found: $srcDir"
    exit 1
}

New-Item -ItemType Directory -Force -Path $androidResDir | Out-Null
New-Item -ItemType Directory -Force -Path $iosTargetDir | Out-Null

function Make-ResourceName($name) {
    # Lowercase, replace non-alnum with underscore, collapse multiple underscores, trim
    $base = [System.IO.Path]::GetFileNameWithoutExtension($name)
    $lower = $base.ToLowerInvariant()
    $sanitized = ($lower -replace '[^a-z0-9]', '_')
    # collapse underscores
    $sanitized = ($sanitized -replace '_{2,}', '_')
    $sanitized = $sanitized.Trim('_')
    if ($sanitized -eq '') { $sanitized = 'sound' }
    # prefix with snd_ to ensure it starts with a letter and avoids collisions
    return "snd_${sanitized}"
}

$mapping = @()
Get-ChildItem -Path $srcDir -File | ForEach-Object {
    $file = $_
    $resourceName = Make-ResourceName($file.Name)
    $ext = [System.IO.Path]::GetExtension($file.Name)
    $androidFileName = "${resourceName}${ext}"
    $androidDest = Join-Path $androidResDir $androidFileName
    $iosDest = Join-Path $iosTargetDir $file.Name

    Copy-Item -Path $file.FullName -Destination $androidDest -Force
    Copy-Item -Path $file.FullName -Destination $iosDest -Force

    $mapping += [PSCustomObject]@{
        File = $file.Name
        AndroidResource = $resourceName
        IOSFileName = $file.Name
    }
}

Write-Host "Copied $($mapping.Count) files.\n"
Write-Host "Mappings (paste into Dart):\n"
foreach ($m in $mapping) {
    $androidLine = "${m.File} -> android raw resource name: ${m.AndroidResource}"
    $iosLine = "${m.File} -> iOS bundle filename: ${m.IOSFileName}"
    Write-Host $androidLine
    Write-Host $iosLine
    Write-Host "---"
}

Write-Host "Notes:\n - After running, add the Android resource names (without extension) to your \`androidRawName\` mapping in Dart.\n - For iOS, use the filename (including extension) in your \`iosFileName\` mapping.\n - Rebuild the app (flutter clean && flutter build) so the native bundles include new files.\n"
