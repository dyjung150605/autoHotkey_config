# AutoHotkey Config

**English** | [한국어](README_ko.md)

Personal AutoHotkey v2 scripts for screen capture workflow automation on Windows.

These scripts bridge the gap where Windows CLI tools (like Claude Code) cannot accept clipboard images directly — instead, they capture the screen, save the image to a file, and copy the **file path** to the clipboard for easy pasting.

## Requirements

- [AutoHotkey v2](https://www.autohotkey.com/)
- Windows 10/11

## Scripts

### `ahks/clip_capture_wintcap_temp.ahk`

| Item | Description |
|---|---|
| Hotkey | `Ctrl+Alt+C` |
| Capture tool | Windows Snipping Tool (`ms-screenclip:`) |
| Save location | `TEMP` folder (default) / custom `SAVE_DIR` |

Capture screen area with Windows Snipping Tool, save as PNG to TEMP folder, copy file path to clipboard.

### `ahks/clip_capture_wincap_dir.ahk`

| Item | Description |
|---|---|
| Hotkey | `Ctrl+Alt+C` |
| Capture tool | Windows Snipping Tool (`ms-screenclip:`) |
| Save location | Custom `SAVE_DIR` (configurable) |

Same as above, but saves to a user-specified directory.

> **Note:** Shares the same hotkey as `wintcap_temp`. Run only one of the two.

### `ahks/clip_capture_pickcap_dir.ahk`

| Item | Description |
|---|---|
| Hotkey | `Shift+F7` |
| Capture tool | [PickPick](https://picpick.app/) (third-party) |
| Save location | Custom `SAVE_DIR` (configurable) |

Integrates with PickPick screen capture — detects the latest saved file in `SAVE_DIR` and copies its path to clipboard. If `SAVE_DIR` matches PickPick's auto-save path, both work together. If set to a different path, images are saved in two locations.

> Can run simultaneously with either `wintcap_temp` or `wincap_dir` (no hotkey conflict).

## Usage

1. Run the `.ahk` script (double-click if installed, or drag onto `AutoHotkey.exe` for portable)
2. Press the assigned hotkey and select the capture area
3. The saved image's file path is now in your clipboard
4. Paste (`Ctrl+V`) the path in Claude Code CLI

## Auto-start

Place a shortcut to the `.ahk` file in the Windows startup folder:

```
Win+R → shell:startup
```

## License

AutoHotkey v2 is licensed under GNU GPL v2. Scripts in this repo are free to use for personal and commercial purposes.
