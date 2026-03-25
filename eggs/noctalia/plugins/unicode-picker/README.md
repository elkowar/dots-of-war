# Unicode Picker

Browse and search Unicode characters directly from the Noctalia launcher.

## Features

- Browse characters by category (Arrows, Mathematical, Greek, Currency, etc.)
- Search by character name or hex codepoint (e.g., `U+2192` or `arrow`)
- Recent characters tracking
- Auto-downloads Unicode character names database
- Copy characters to clipboard with a single click

## Usage

1. Open the launcher
2. Type `>unicode` to enter Unicode mode
3. Browse categories or search for characters
4. Click a character to copy it to clipboard

## IPC Toggle

You can toggle the Unicode picker via IPC:

```bash
quickshell ipc call plugin:unicode toggle
```

## Categories

- Recent (recently used characters)
- Arrows
- Mathematical
- Box Drawing
- Block Elements
- Geometric
- Misc Symbols
- Currency
- Greek
- Cyrillic
- Technical
- Superscripts
- Number Forms
- Dingbats
- Latin Extended
- Braille
