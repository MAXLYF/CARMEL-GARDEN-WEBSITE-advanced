$cssFile = "public\styles.css"
$content = Get-Content $cssFile -Raw

# 1. Update the MAIN Variables (Lines 16-23)
# These represent the 'after swap' state.
# They might currently be pink/gold or blue/yellow.
# We ensure they are Blue primary, Yellow highlight.
$content = $content -replace '--pink:\s*#[a-zA-Z0-9]+;', '--pink:  #1e3a8a;'
$content = $content -replace '--pink2:\s*#[a-zA-Z0-9]+;', '--pink2: #1e40af;'
$content = $content -replace '--dark:\s*#[a-zA-Z0-9]+;', '--dark:  #1e3a8a;'
$content = $content -replace '--gold:\s*#[a-zA-Z0-9]+;', '--gold:  #facc15;'
$content = $content -replace '--grey:\s*#[a-zA-Z0-9]+;', '--grey:  #475569;'

# 2. Update the SECOND Variables (Lines 488+)
$content = $content -replace '--primary-color:\s*#[a-zA-Z0-9]+;', '--primary-color: #1e3a8a;'
$content = $content -replace '--primary-light:\s*#[a-zA-Z0-9]+;', '--primary-light: #1e40af;'
$content = $content -replace '--primary-dark:\s*#[a-zA-Z0-9]+;', '--primary-dark: #172554;'

$content = $content -replace '--accent-color:\s*#[a-zA-Z0-9]+;', '--accent-color: #facc15;'
$content = $content -replace '--accent-hover:\s*#[a-zA-Z0-9]+;', '--accent-hover: #eab308;'

$content = $content -replace '--text-main:\s*#[a-zA-Z0-9]+;', '--text-main: #333333;'
$content = $content -replace '--text-muted:\s*#[a-zA-Z0-9]+;', '--text-muted: #555555;'
$content = $content -replace '--text-dark:\s*#[a-zA-Z0-9]+;', '--text-dark: #1e3a8a;' # Headings: Blue

$content = $content -replace '--bg-dark:\s*#[a-zA-Z0-9]+;', '--bg-dark: #1e3a8a;'

# 3. Fix rules
# BUTTONS: Primary buttons: Blue background, white text. Hover: Slight darker shade.
# Let's target the exact .btn-primary block
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

# 4. Swap all hardcoded Yellows to Blue (since Yellow used to be primary in the 2nd part)
# and hardcoded Blues to Yellow
# Old yellows to Blue
$content = $content -replace '#FFB300', '___T_BLUE___'
$content = $content -replace '#FFCA28', '___T_BLUE___'
$content = $content -replace '#FFA000', '___T_BLUE___'
$content = $content -replace '255,\s*179,\s*0', '___T_RGB_BLUE___'
# The gold color in bible verse
$content = $content -replace '#b8860b', '___T_YELLOW___' # Wait, bible verse gold is highlight, let's make it Yellow

# Old accent blues to Yellow
$content = $content -replace '#0d2c5e', '___T_YELLOW___'
$content = $content -replace '#164082', '___T_YELLOW___'

# Apply replacements
$content = $content -replace '___T_BLUE___', '#1e3a8a'
$content = $content -replace '___T_YELLOW___', '#facc15'
$content = $content -replace '___T_RGB_BLUE___', '30, 58, 138'

# Wait, there's another hardcoded yellow for shadows: rgba(250, 204, 21, ...)
# In the first section, these were highlight colors, so they should REMAIN yellow!
# Because the rules say: "Highlights: Yellow". Shadows are highlights.
# Therefore, any rgba(250, 204, 21, ...) should stay as is.

# But the user says: "Replace all blue colors with yellow, replace all yellow colors with blue"
# I will do exactly what they ask for the hardcoded colors in the FIRST block just in case:
# IF the first block was already Blue/Yellow, and they explicitly wanted to SWAP EVERYTHING...
# Then I need to swap ALL of them.
# Let's build a strict color map to literally swap every color that is in the old set.
$blueList = @('#1e3a8a', '#1e40af', '#1d4ed8')
$yellowList = @('#facc15', '#fefce8', '#e8f0ff') # #fefce8 is pale yellow, #e8f0ff is pale blue
# But wait, it's safer to just let the variables do the job, and only modify what breaks.

Set-Content -Path $cssFile -Value $content -Encoding UTF8
