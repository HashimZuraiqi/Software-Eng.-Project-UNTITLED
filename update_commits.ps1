# update_commits.ps1 — Run before tagging to refresh commit counts in README.md

$readme = "README.md"
$members = @{
    "Hashim Zuraiqi"    = @("Hashim Zuraiqi")
    "Mohammad Abu Taha" = @("Mohammad Abu Taha")
    "Faris Asaad"       = @("Faris Asaad", "Faris")
    "Hytham Fares"      = @("hytham2005", "hythamfares2005")
}

$content = Get-Content $readme -Raw

foreach ($name in $members.Keys) {
    $count = 0
    foreach ($alias in $members[$name]) {
        $count += [int](git log --all --oneline --author="$alias" | Measure-Object).Count
    }
    # Replace the row: | Name | ... | OLD_COUNT |  →  | Name | ... | NEW_COUNT |
    $content = $content -replace "(\|\s*$([regex]::Escape($name))\s*\|[^|]+\|)\s*\d+\s*\|", "`$1 $count |"
}

Set-Content $readme $content -NoNewline
Write-Host "README.md commit counts updated."
