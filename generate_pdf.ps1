# generate_pdf.ps1
# Run this script AFTER all diagram PNGs are in docs/images/
# It generates docs/se_report_group_10.pdf using Pandoc
# 
# Usage: .\generate_pdf.ps1
# Requires: Pandoc (already installed at C:\Users\hashi\AppData\Local\Pandoc\pandoc.exe)
#           AND one of: wkhtmltopdf OR a Chromium-based browser for printing

$pandoc = "C:\Users\hashi\AppData\Local\Pandoc\pandoc.exe"
$docsDir = Join-Path $PSScriptRoot "docs"
$inputFile = Join-Path $docsDir "report.md"
$cssFile = Join-Path $docsDir "report_style.css"
$htmlOut = Join-Path $docsDir "se_report_group_10.html"
$pdfOut = Join-Path $docsDir "se_report_group_10.pdf"

Write-Host "=== Generating HTML report ===" -ForegroundColor Cyan
Push-Location $docsDir
& $pandoc report.md --standalone --embed-resources --css report_style.css `
    --resource-path "." `
    --metadata title="Library Management System - SE Report Group 10" `
    -o se_report_group_10.html

if ($LASTEXITCODE -eq 0) {
    Write-Host "HTML generated: $htmlOut" -ForegroundColor Green
} else {
    Write-Host "ERROR generating HTML" -ForegroundColor Red
    Pop-Location
    exit 1
}

Write-Host ""
Write-Host "=== Attempting PDF generation ===" -ForegroundColor Cyan

# Try wkhtmltopdf first
$wkhtmltopdf = Get-Command wkhtmltopdf -ErrorAction SilentlyContinue
if ($wkhtmltopdf) {
    Write-Host "Using wkhtmltopdf..." -ForegroundColor Yellow
    & wkhtmltopdf --enable-local-file-access $htmlOut $pdfOut
    if ($LASTEXITCODE -eq 0) {
        Write-Host "PDF generated: $pdfOut" -ForegroundColor Green
    }
} else {
    Write-Host "wkhtmltopdf not found." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "=== MANUAL STEP REQUIRED ===" -ForegroundColor Magenta
    Write-Host "Open the HTML file in Chrome or Edge and print to PDF:" -ForegroundColor White
    Write-Host "  File: $htmlOut" -ForegroundColor White
    $steps = "  Steps: Open file -> Ctrl+P -> Save as PDF -> 'se_report_group_10.pdf'"
    Write-Host $steps -ForegroundColor White
    Write-Host "  Save to: $docsDir" -ForegroundColor White
    
    # Open the file automatically
    $arg = "`"$htmlOut`""
    Start-Process -FilePath "explorer.exe" -ArgumentList $arg
}

Pop-Location