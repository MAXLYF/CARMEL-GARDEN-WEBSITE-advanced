$cssFile = "public\styles.css"
$content = Get-Content $cssFile -Raw

# Temporary placeholders
$tmpYellow = "___TMP_Y1___"
$tmpDarkYellow = "___TMP_Y2___"
$tmpLightYellow = "___TMP_Y3___"

$tmpRgbYellow = "___TMP_Y4___"
$tmpRgbDarkYellow = "___TMP_Y5___"

# 1. Replace Yellows with Temp Placeholders
# #FFC107
$content = $content -replace '(?i)#FFC107', $tmpYellow
# #E0A800
$content = $content -replace '(?i)#E0A800', $tmpDarkYellow
# #FFF8E1
$content = $content -replace '(?i)#FFF8E1', $tmpLightYellow
# 255, 193, 7
$content = $content -replace '255,\s*193,\s*7', $tmpRgbYellow
# 224, 168, 0
$content = $content -replace '224,\s*168,\s*0', $tmpRgbDarkYellow

# 2. Replace Blues with Yellow values
# #0D6EFD -> #FFC107
$content = $content -replace '(?i)#0D6EFD', '#FFC107'
# #0A58CA -> #E0A800
$content = $content -replace '(?i)#0A58CA', '#E0A800'
# #E7F1FF -> #FFF8E1
$content = $content -replace '(?i)#E7F1FF', '#FFF8E1'
# 13, 110, 253 -> 255, 193, 7
$content = $content -replace '13,\s*110,\s*253', '255, 193, 7'
# Wait, did I use Dark blue RGB in the previous output? Let me check string:
# I had `rgba(13, 110, 253, 0.5)`
# There was no dark blue RGB unless I mapped it. Let's just map the ones I know.

# 3. Replace Temp Placeholders with Blue values
$content = $content -replace $tmpYellow, '#0D6EFD'
$content = $content -replace $tmpDarkYellow, '#0A58CA'
$content = $content -replace $tmpLightYellow, '#E7F1FF'
$content = $content -replace $tmpRgbYellow, '13, 110, 253'
$content = $content -replace $tmpRgbDarkYellow, '10, 88, 202'

# 4. Fix button text contrast
# Now .hero-btn has background: #0D6EFD (Blue), so its color should be #ffffff instead of #111111
# The previous block was:
# .hero-btn {
#     background: #FFC107 !important;
#     color: #111111 !important;
$content = $content -replace '(\.hero-btn\s*\{[^}]*background:\s*)#0D6EFD([^}]*color:\s*)#111111', '$1#0D6EFD$2#ffffff'
$content = $content -replace '(\.hero-btn:hover\s*\{[^}]*background:\s*)#0A58CA([^}]*color:\s*)#111111', '$1#0A58CA$2#ffffff'

$content = $content -replace '(\.btn-primary[^{]*\{[^}]*background:\s*)#0D6EFD([^}]*color:\s*)#111111', '$1#0D6EFD$2#ffffff'
$content = $content -replace '(\.btn-primary:hover[^{]*\{[^}]*background:\s*)#0A58CA([^}]*color:\s*)#111111', '$1#0A58CA$2#ffffff'

# .view-all-btn, .btn-secondary now have background: #FFC107 (Yellow)
# so their color should be #111111 instead of #ffffff
$content = $content -replace '(\.view-all-btn[^{]*\{[^}]*background:\s*)#FFC107([^}]*color:\s*)#ffffff', '$1#FFC107$2#111111'
$content = $content -replace '(\.view-all-btn:hover[^{]*\{[^}]*background:\s*)#E0A800([^}]*color:\s*)#ffffff', '$1#E0A800$2#111111'

Set-Content -Path $cssFile -Value $content -Encoding UTF8
