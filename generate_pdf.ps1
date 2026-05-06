# generate_pdf.ps1
# Generates docs/se_report_group_10.html using Pandoc
#
# Usage: .\generate_pdf.ps1
# Requires: Pandoc  at C:\Users\hashi\AppData\Local\Pandoc\pandoc.exe

$pandoc  = "C:\Users\hashi\AppData\Local\Pandoc\pandoc.exe"
$root    = $PSScriptRoot
$docsDir = Join-Path $root "docs"
$htmlOut = Join-Path $docsDir "se_report_group_10.html"

Write-Host "=== Generating HTML (README as title page) ===" -ForegroundColor Cyan
Push-Location $docsDir

# Pandoc accepts multiple input files and concatenates them in order.
& $pandoc `
    ..\README.md `
    report.md `
    --standalone `
    --embed-resources `
    --css report_style.css `
    --resource-path "." `
    -o se_report_group_10.html

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Pandoc failed." -ForegroundColor Red
    Pop-Location
    exit 1
}

Write-Host "HTML OK: $htmlOut" -ForegroundColor Green
Pop-Location

Write-Host ""
Write-Host "=== MANUAL STEP REQUIRED ===" -ForegroundColor Magenta
Write-Host "Open the HTML file in your browser and print to PDF:" -ForegroundColor White
$steps = "  Steps: Open file -> Ctrl+P -> Save as PDF -> 'se_report_group_10.pdf'"
Write-Host $steps -ForegroundColor White
Write-Host "  Remember to set margins to 'None' to hide file paths." -ForegroundColor White

$arg = "`"$htmlOut`""
Start-Process -FilePath "explorer.exe" -ArgumentList $arg