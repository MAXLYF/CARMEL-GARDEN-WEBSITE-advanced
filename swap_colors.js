const fs = require('fs');
const path = require('path');

const cssPath = path.join(__dirname, 'public', 'styles.css');
let css = fs.readFileSync(cssPath, 'utf8');

// The new colors to use
const BLUE = '#1e3a8a';
const BLUE_HOVER = '#1e40af';
const YELLOW = '#facc15';
const YELLOW_HOVER = '#eab308';
const RGB_BLUE = '30, 58, 138';
const RGB_YELLOW = '250, 204, 21';

// Let's rewrite the :root variables directly.
// First :root block:
// Currently:
//   --pink:  #1e3a8a;
//   --pink2: #1e40af;
//   --dark:  #1e3a8a;
//   --gold:  #facc15;
// It ALREADY is Blue/Yellow correctly for primary/highlight!
// BUT we should make sure the variables are correctly named and used. Wait, we don't need to change variable names, just ensure their values.
css = css.replace(/--pink:\s*#[a-zA-Z0-9]+;/g, `--pink: ${BLUE};`);
css = css.replace(/--pink2:\s*#[a-zA-Z0-9]+;/g, `--pink2: ${BLUE_HOVER};`);
css = css.replace(/--dark:\s*#[a-zA-Z0-9]+;/g, `--dark: ${BLUE};`);
css = css.replace(/--gold:\s*#[a-zA-Z0-9]+;/g, `--gold: ${YELLOW};`);

// Second :root block:
// Currently:
//   --primary-color: #FFB300;
//   --primary-light: #FFCA28;
//   --primary-dark: #FFA000;
//   --accent-color: #0d2c5e;
//   --accent-hover: #164082;
// We need to swap them!
css = css.replace(/--primary-color:\s*#[a-zA-Z0-9]+;/g, `--primary-color: ${BLUE};`);
css = css.replace(/--primary-light:\s*#[a-zA-Z0-9]+;/g, `--primary-light: #3b82f6;`); // lighter blue
css = css.replace(/--primary-dark:\s*#[a-zA-Z0-9]+;/g, `--primary-dark: ${BLUE_HOVER};`);

css = css.replace(/--accent-color:\s*#[a-zA-Z0-9]+;/g, `--accent-color: ${YELLOW};`);
css = css.replace(/--accent-hover:\s*#[a-zA-Z0-9]+;/g, `--accent-hover: ${YELLOW_HOVER};`);

// Also bg-dark:
css = css.replace(/--bg-dark:\s*#[a-zA-Z0-9]+;/g, `--bg-dark: ${BLUE};`); // from FF3B00 to blue

// Now let's handle hardcoded replacements.
// Rule: replace old blue with new yellow?
// Wait! If we swap Yellow to Blue, we want all hardcoded #FFB300, #FFCA28, #FFA000 to be Blue.
// And all hardcoded #0d2c5e, #164082 to be Yellow.
// But some places might hardcode rgba(255, 179, 0, ...) -> which is Yellow, needs to be Blue -> rgba(30, 58, 138, ...)
// Wait, the prompt says "Replace ALL blue colors with yellow. Replace ALL yellow colors with blue."
// So literally:
// ANY blue hex/rgb -> YELLOW
// ANY yellow hex/rgb -> BLUE

// Let's list old blues:
const oldBlues = ['#1e3a8a', '#1e40af', '#1d4ed8', '#0d2c5e', '#164082', '#172554'];
const oldBluesRgb = ['30, 58, 138', '30, 64, 175', '29, 78, 216', '13, 44, 94', '22, 64, 130', '23, 37, 84'];

// Let's list old yellows:
const oldYellows = ['#facc15', '#FFB300', '#FFCA28', '#FFA000', '#b8860b', '#eab308'];
const oldYellowsRgb = ['250, 204, 21', '255, 179, 0', '255, 202, 40', '255, 160, 0', '184, 134, 11', '234, 179, 8'];

// We need a unique placeholder to safely swap.
const PLACEHOLDER_BLUE = '___TMP_BLUE___';
const PLACEHOLDER_YELLOW = '___TMP_YELLOW___';
const PLACEHOLDER_RGB_BLUE = '___TMP_RGB_BLUE___';
const PLACEHOLDER_RGB_YELLOW = '___TMP_RGB_YELLOW___';

// To be safe and precise, we will replace case insensitively.
oldBlues.forEach(color => {
    css = css.replace(new RegExp(color, 'gi'), PLACEHOLDER_YELLOW); // Blue -> Yellow placeholder
});
oldBluesRgb.forEach(color => {
    // Escape commas and spaces for regex
    const regex = new RegExp(color.replace(/,\s*/g, ',\\s*'), 'gi');
    css = css.replace(regex, PLACEHOLDER_RGB_YELLOW);
});

oldYellows.forEach(color => {
  css = css.replace(new RegExp(color, 'gi'), PLACEHOLDER_BLUE); // Yellow -> Blue placeholder
});
oldYellowsRgb.forEach(color => {
  const regex = new RegExp(color.replace(/,\s*/g, ',\\s*'), 'gi');
  css = css.replace(regex, PLACEHOLDER_RGB_BLUE);
});

// Now replace placeholders with the final exact colors
css = css.replace(new RegExp(PLACEHOLDER_BLUE, 'g'), BLUE);
css = css.replace(new RegExp(PLACEHOLDER_YELLOW, 'g'), YELLOW);
css = css.replace(new RegExp(PLACEHOLDER_RGB_BLUE, 'g'), RGB_BLUE);
css = css.replace(new RegExp(PLACEHOLDER_RGB_YELLOW, 'g'), RGB_YELLOW);

fs.writeFileSync(cssPath, css);
console.log('Swapped colors successfully!');
