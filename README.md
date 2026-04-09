# AutoHotkey Config

**English** | [한국어](README_ko.md)

A collection of personal AutoHotkey v2 scripts for Windows workflow automation.

## Requirements

- [AutoHotkey v2](https://www.autohotkey.com/)
- Windows 10/11

---

## 1. Screen Capture & Clipboard Path

Scripts that bridge the gap where Windows CLI tools (like Claude Code) cannot accept clipboard images directly — capture the screen, save the image to a file, and copy the **file path** to the clipboard for easy pasting.

> **Known limitation:** These scripts are tested with **region capture (area selection) only**. Other capture modes (active window, scroll capture, full screen, etc.) may not work correctly.

### 1-1. Using Windows Snipping Tool

#### `ahks/clip_capture_wintcap_temp.ahk`

| Item | Description |
|---|---|
| Hotkey | `Ctrl+Alt+C` |
| Capture tool | Windows Snipping Tool (`ms-screenclip:`) |
| Save location | `TEMP` folder (default) / custom `SAVE_DIR` |

Capture screen area with Windows Snipping Tool, save as PNG to TEMP folder, copy file path to clipboard.

#### `ahks/clip_capture_wincap_dir.ahk`

| Item | Description |
|---|---|
| Hotkey | `Ctrl+Alt+C` |
| Capture tool | Windows Snipping Tool (`ms-screenclip:`) |
| Save location | Custom `SAVE_DIR` (configurable) |

Same as above, but saves to a user-specified directory.

> **Note:** Shares the same hotkey as `wintcap_temp`. Run only one of the two.

### 1-2. Using PickPick (Third-party)

#### `ahks/clip_capture_pickcap_dir.ahk`

| Item | Description |
|---|---|
| Hotkey | `Ctrl+Alt+PrtSc` (configurable, PickPick default) |
| Capture tool | [PickPick](https://picpick.app/) |
| Save location | `TEMP` folder |

Integrates with PickPick screen capture — saves the clipboard image to TEMP independently of PickPick's own auto-save path, then copies the file path to clipboard.

> **Note:** `Ctrl+Alt+PrtSc` is the PickPick default for region capture. Change the `~^!PrintScreen` line in the script to match your own PickPick hotkey.

> Can run simultaneously with any of the Windows Snipping Tool scripts (no hotkey conflict).

---

## Usage

1. Run the `.ahk` script (double-click if installed, or drag onto `AutoHotkey.exe` for portable)
2. Press the assigned hotkey and select the capture area
3. The saved image's file path is now in your clipboard
4. Paste (`Ctrl+V`) the path in Claude Code CLI

## Auto-start

Place a shortcut to the `.ahk` file in the Windows startup folder:

```text
Win+R → shell:startup
```

## License

AutoHotkey v2 is licensed under GNU GPL v2. Scripts in this repo are free to use for personal and commercial purposes.
