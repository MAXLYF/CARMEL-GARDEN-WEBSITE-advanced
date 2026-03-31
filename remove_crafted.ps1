$rootDir = "public"
$htmlFiles = Get-ChildItem -Path $rootDir -Filter *.html -Recurse

foreach ($file in $htmlFiles) {
    $content = Get-Content -Path $file.FullName -Raw
    # Define the target text to remove.
    # We use a regex that matches the line, including optional leading whitespace and trailing newlines.
    $pattern = '(?m)^[ \t]*<span>Crafted with ❤️ for Carmel Garden</span>\r?\n?'
    
    if ($content -match $pattern) {
        $newContent = $content -replace $pattern, ''
        Set-Content -Path $file.FullName -Value $newContent -Encoding UTF8
        Write-Host "Removed from $($file.Name)"
    }
}
