$cssFile = "public\styles.css"
$content = Get-Content $cssFile -Raw

# 1. ADD GOOGLE FONTS IMPORT
$importStr = "@import url('https://fonts.googleapis.com/css2?family=Great+Vibes&display=swap');`n"
if ($content -notmatch "Great\+Vibes") {
    $content = $importStr + $content
}

# 2. OVERRIDE VARIABLES BY REPLACING OLD VALUES
# We will globally replace the hex colors in the variables blocks to avoid conflicts, and then add our new system.

$content = $content -replace '--pink:\s*#[0-9a-fA-F]+;', '--pink: #FFC107;'
$content = $content -replace '--pink2:\s*#[0-9a-fA-F]+;', '--pink2: #E0A800;'
$content = $content -replace '--dark:\s*#[0-9a-fA-F]+;', '--dark: #0D6EFD;'
$content = $content -replace '--gold:\s*#[0-9a-fA-F]+;', '--gold: #FFC107;'
$content = $content -replace '--light:\s*#[0-9a-fA-F]+;', '--light: #FFF8E1;'
$content = $content -replace '--grey:\s*#[0-9a-fA-F]+;', '--grey: #666666;'

$content = $content -replace '--primary-color:\s*#[0-9a-fA-F]+;', '--primary-color: #FFC107;'
$content = $content -replace '--primary-light:\s*#[0-9a-fA-F]+;', '--primary-light: #FFF8E1;'
$content = $content -replace '--primary-dark:\s*#[0-9a-fA-F]+;', '--primary-dark: #E0A800;'

$content = $content -replace '--accent-color:\s*#[0-9a-fA-F]+;', '--accent-color: #0D6EFD;'
$content = $content -replace '--accent-hover:\s*#[0-9a-fA-F]+;', '--accent-hover: #0A58CA;'

$content = $content -replace '--text-main:\s*#[0-9a-fA-F]+;', '--text-main: #333333;'
$content = $content -replace '--text-muted:\s*#[0-9a-fA-F]+;', '--text-muted: #666666;'
$content = $content -replace '--text-dark:\s*#[0-9a-fA-F]+;', '--text-dark: #0D6EFD;'

$content = $content -replace '--bg-light:\s*#[0-9a-fA-F]+;', '--bg-light: #FFF8E1;'
$content = $content -replace '--bg-dark:\s*#[0-9a-fA-F]+;', '--bg-dark: #1e293b;'

# 3. FIX GRADIENTS (REMOVE ALL PINK/PURPLE/WEIRD GRADIENTS)
$content = $content -replace 'linear-gradient\(90deg, var\(--pink\), var\(--pink2\)\)', '#FFC107'
$content = $content -replace 'linear-gradient\(135deg,\s*#ffe0f3,\s*#dce8ff\)', '#FFF8E1'
$content = $content -replace 'linear-gradient\(135deg, var\(--dark\) 0%, #1d4ed8 100%\)', '#0D6EFD'
$content = $content -replace 'linear-gradient\(135deg,\s*#facc15 0%,\s*var\(--pink\) 100%\)', 'linear-gradient(135deg, #FFC107 0%, #E0A800 100%)'
$content = $content -replace 'linear-gradient\(135deg,\s*#fefce8,\s*#e8f0ff\)', '#E7F1FF'
$content = $content -replace 'linear-gradient\(135deg,\s*var\(--dark\),\s*#1d4ed8\)', '#0D6EFD'
$content = $content -replace 'linear-gradient\(135deg, var\(--pink\), var\(--pink2\)\)', '#FFC107'
$content = $content -replace 'linear-gradient\(135deg,\s*rgba\(250, 204, 21,\.72\)\s*20%,\s*rgba\(250, 204, 21,\.48\)\)', 'linear-gradient(135deg, rgba(255, 193, 7, 0.8) 0%, rgba(224, 168, 0, 0.6) 100%)'
$content = $content -replace 'linear-gradient\(to right,\s*rgba\(0, 0, 0, 0\.8\)\s*0%,\s*rgba\(13, 110, 253, 0\.3\)\s*100%\)', 'linear-gradient(to right, rgba(0, 0, 0, 0.85) 0%, rgba(13, 110, 253, 0.5) 100%)'

# Replace any lingering pink/purple hex codes
$content = $content -replace '#ffe0f3', '#E7F1FF'
$content = $content -replace '#dce8ff', '#E7F1FF'

# Fix the 255,179,0 rgba values to new yellow
$content = $content -replace '255,\s*179,\s*0', '255, 193, 7'
$content = $content -replace '30,\s*58,\s*138', '13, 110, 253'

# 4. APPEND NEW CSS OVERRIDES
$overrides = @"

/* =========================================================================
   NEW REDESIGN OVERRIDES (YELLOW & BLUE THEME)
   ========================================================================= */

/* FONT STYLE */
h1#cms-brand-name, .logo h1, .brand-text h1, .brand-col h2 {
    font-family: 'Great Vibes', cursive !important;
    font-size: 2.5rem !important;
    background: linear-gradient(135deg, #0D6EFD, #0A58CA);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    font-weight: 500 !important;
    text-transform: none !important;
    letter-spacing: 1px !important;
}

/* NAVBAR */
.navbar {
    background: #ffffff !important;
}
.nav-link {
    color: #333333 !important;
}
.nav-link:hover, .nav-link.active {
    color: #0D6EFD !important;
    background: transparent !important;
}
.nav-link::after {
    background-color: #FFC107 !important;
}

/* HERO SECTION CTA */
.hero-btn {
    background: #FFC107 !important;
    color: #111111 !important;
    border-radius: 30px !important;
    font-weight: 700 !important;
    transition: all 0.3s ease !important;
}
.hero-btn:hover {
    background: #E0A800 !important;
    color: #111111 !important;
}

/* BUTTON DESIGN */
.btn-primary, .nav-apply, .apply-topbtn, .explore-btn, .read-more, .carousel-nav-btn {
    background: #FFC107 !important;
    color: #111111 !important;
    border-radius: 30px !important;
    transition: all 0.3s ease !important;
}
.btn-primary:hover, .nav-apply:hover, .apply-topbtn:hover, .explore-btn:hover, .read-more:hover, .carousel-nav-btn:hover {
    background: #E0A800 !important;
    color: #111111 !important;
}

.view-all-btn, .btn-secondary {
    background: #0D6EFD !important;
    color: #ffffff !important;
    border-radius: 30px !important;
    transition: all 0.3s ease !important;
}
.view-all-btn:hover, .btn-secondary:hover {
    background: #0A58CA !important;
    color: #ffffff !important;
}

/* CARDS */
.principal-card, .campus-card, .upd-card, .feature-card, .curriculum-card, .fac-card, .folder-card {
    background: #ffffff !important;
    box-shadow: 0 4px 15px rgba(0,0,0,0.05) !important;
    border: 1px solid #E7F1FF !important;
    border-bottom: 3px solid #FFC107 !important;
    transition: transform 0.3s ease, box-shadow 0.3s ease !important;
}
.principal-card:hover, .campus-card:hover, .upd-card:hover, .feature-card:hover, .curriculum-card:hover, .fac-card:hover, .folder-card:hover {
    transform: translateY(-5px) !important;
    box-shadow: 0 10px 25px rgba(0,0,0,0.1) !important;
    border-bottom: 3px solid #0D6EFD !important;
}

/* TEXT STYLING */
h1, h2, h3, h4, h5, h6 {
    color: #0D6EFD !important;
}
body {
    color: #333333;
}
p {
    color: #333333;
}
.text-muted, .sec-tag, .form-card p, .fac-card-body p, .about-text p, .curriculum-card p, .feature-card p {
    color: #666666 !important;
}

/* FOOTER */
footer, .footer {
    background: #1e293b !important;
}
footer h2, footer h3, footer h4, .footer h2, .footer h3, .footer h4 {
    color: #ffffff !important;
}
footer p, .footer p, footer .footer-top, footer .footer-bottom, .footer .footer-bottom, footer li, footer a, footer div {
    color: #e2e8f0;
}
footer a:hover, .footer a:hover, .social-links a:hover, footer .soc-links a:hover {
    color: #FFC107 !important;
}

/* FIX ANY INCONSISTENT HERO OVERLAYS */
.hero-slide::before {
    background: rgba(0, 0, 0, 0.7) !important;
}

/* FIX BADGES & LABELS */
.sec-tag {
    background: #E7F1FF !important;
    color: #0D6EFD !important;
}

"@

$content = $content + "`n" + $overrides

Set-Content -Path $cssFile -Value $content -Encoding UTF8
