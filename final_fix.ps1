$content = Get-Content -Path "public\styles.css" -Raw

# 1. Update second block to use the PROPER blue/yellow rules
# Old primary (was yellow) becomes Blue #1e3a8a
$content = $content -replace '--primary-color:\s*#[0-9a-fA-F]+;', '--primary-color: #1e3a8a;'
$content = $content -replace '--primary-light:\s*#[0-9a-fA-F]+;', '--primary-light: #1e40af;'
$content = $content -replace '--primary-dark:\s*#[0-9a-fA-F]+;', '--primary-dark: #172554;'

# Old accent (was blue) becomes Yellow #facc15
$content = $content -replace '--accent-color:\s*#[0-9a-fA-F]+;', '--accent-color: #facc15;'
$content = $content -replace '--accent-hover:\s*#[0-9a-fA-F]+;', '--accent-hover: #eab308;'

# Backgrounds
$content = $content -replace '--bg-dark:\s*#[0-9a-fA-F]+;', '--bg-dark: #1e3a8a;'

# Headings to Blue
$content = $content -replace '--text-dark:\s*#[0-9a-fA-F]+;', '--text-dark: #1e3a8a;'

# 2. Fix the hardcoded RGBA (255, 179, 0 is #FFB300, which is the old yellow)
$content = $content -replace '255,\s*179,\s*0', '30, 58, 138'

# 3. What about the hardcoded FA icons or colors using #FFB300 in the HTML? 
# The prompt says css only: "Provide updated CSS only. Do not change HTML structure."

# 4. Fix .btn-primary background and text
$btnPrimaryOld = '.btn-primary {
    background-color: var(--text-dark);
    color: var(--primary-color);
}'
$btnPrimaryNew = '.btn-primary {
    background-color: var(--primary-color);
    color: #ffffff;
}'
$content = $content.Replace($btnPrimaryOld, $btnPrimaryNew)

$btnPrimaryHoverOld = '.btn-primary:hover {
    background-color: #333;
    transform: translateY(-3px);
    box-shadow: 0 5px 15px rgba(0,0,0,0.3);
}'
$btnPrimaryHoverNew = '.btn-primary:hover {
    background-color: var(--primary-dark);
    color: #ffffff;
    transform: translateY(-3px);
    box-shadow: 0 5px 15px rgba(30, 58, 138, 0.4);
}'
$content = $content.Replace($btnPrimaryHoverOld, $btnPrimaryHoverNew)

# 5. Fix remaining stragglers based on standard values
# If there are any other #FFB300, make them #1e3a8a
$content = $content -ireplace '#FFB300', '#1e3a8a'
$content = $content -ireplace '#FFCA28', '#1e40af'
$content = $content -ireplace '#FFA000', '#172554'

# Any other #0d2c5e (Navy blue), make it #facc15 (Yellow)
$content = $content -ireplace '#0d2c5e', '#facc15'
$content = $content -ireplace '#164082', '#eab308'

# Wait, but what if there's any stray --pink or --gold that isn't mapped properly?
# As we checked, the 1st root block has --pink: #1e3a8a and --gold: #facc15, perfectly correct.

Set-Content -Path "public\styles.css" -Value $content -Encoding UTF8
