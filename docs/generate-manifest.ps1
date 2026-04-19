# ============================================================
#  generate-manifest.ps1
#  Happy Birthday Abby! 💛
#
#  PURPOSE:
#    Scans the /images folder and writes images-manifest.json
#    so the gallery can load all photos dynamically.
#
#  HOW TO RUN:
#    1. Place all your images inside the "images" folder
#       (JPG, JPEG, PNG, WEBP, GIF, AVIF, BMP are supported)
#    2. Open PowerShell in the same folder as this script
#    3. Run:
#         powershell -ExecutionPolicy Bypass -File generate-manifest.ps1
#    4. Open index.html in your browser (or use Live Server)
# ============================================================

$scriptDir    = Split-Path -Parent $MyInvocation.MyCommand.Definition
$imagesFolder = Join-Path $scriptDir "images"
$manifestPath = Join-Path $scriptDir "images-manifest.json"

$supportedExts = @("*.jpg", "*.jpeg", "*.png", "*.gif", "*.webp", "*.avif", "*.bmp")

if (-not (Test-Path $imagesFolder)) {
    Write-Host "ERROR: 'images' folder not found. Create it and add your photos." -ForegroundColor Red
    exit 1
}

$imageFiles = @()

foreach ($pattern in $supportedExts) {
    $files = Get-ChildItem -Path $imagesFolder -Filter $pattern -File |
             Select-Object -ExpandProperty Name
    foreach ($f in $files) {
        $imageFiles += "images/$f"
    }
}

# Build JSON manifest
$manifest = [ordered]@{ images = $imageFiles } | ConvertTo-Json -Depth 3
Set-Content -Path $manifestPath -Value $manifest -Encoding UTF8

# Report
Write-Host ""
Write-Host "========================================" -ForegroundColor Yellow
Write-Host "  Birthday Gallery Manifest Generated!  " -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Yellow
Write-Host ""
Write-Host "  Found $($imageFiles.Count) image(s):" -ForegroundColor Cyan
$imageFiles | ForEach-Object { Write-Host "    - $_" -ForegroundColor White }
Write-Host ""
Write-Host "  Manifest saved -> $manifestPath" -ForegroundColor Green
Write-Host ""
Write-Host "  Now open index.html in your browser!  💛" -ForegroundColor Yellow
Write-Host ""
