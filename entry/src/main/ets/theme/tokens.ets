// H01 Foundation Tokens (scaffold, per HarmonyOS spec H01).
// All values are PROVISIONAL/C-level seeds until simulator Geometry/Token calibration.
// Business UI must reference these tokens, never raw literals.

// Colors (C-level video samples -> seeds only)
export const THINGS_COLOR_BG_PRIMARY: string = '#FFFFFF';
export const THINGS_COLOR_TEXT_PRIMARY: string = '#1C1C1E';
export const THINGS_COLOR_TEXT_SECONDARY: string = '#8A8A8E';
export const THINGS_COLOR_ACCENT: string = '#0055B8';          // checkbox completed blue (seed)
export const THINGS_COLOR_CHECKBOX_STROKE: string = '#B7BBBF'; // open checkbox border (seed)
export const THINGS_COLOR_DEADLINE: string = '#F6164A';        // deadline accent (seed)
export const THINGS_COLOR_SELECTED_BG: string = '#E8F0FE';     // multi-select row bg (light blue) PROVISIONAL

// Spacing (vp)
export const THINGS_SPACE_XS: number = 4;
export const THINGS_SPACE_SM: number = 8;
export const THINGS_SPACE_MD: number = 12;
export const THINGS_SPACE_LG: number = 20;

// Page padding (vp), low-chrome: whitespace carries the hierarchy.
export const THINGS_PADDING_PAGE: number = 20;

// Radius (vp)
export const THINGS_RADIUS_MD: number = 12;

// Hit target (vp) — visual size and hit target are separated.
export const THINGS_HIT_TARGET: number = 48;
export const THINGS_CHECKBOX_VISUAL: number = 18;

// Typography (fp)
export const THINGS_FONT_PAGE: number = 30;    // large page title (Today / Things)
export const THINGS_FONT_SECTION: number = 20; // section heading
export const THINGS_FONT_TITLE: number = 17;   // todo title
export const THINGS_FONT_BODY: number = 15;
export const THINGS_FONT_METADATA: number = 12;
