# AutoHotkey Config

**English** | [한국어](README_ko.md)

A collection of personal AutoHotkey v2 scripts for Windows workflow automation.

## Requirements

- [AutoHotkey v2](https://www.autohotkey.com/)
- Windows 10/11

---

## 1. Clipboard Image → Smart Paste

For environments where Claude Code CLI and GUI are used side by side.

**Background:** Claude Code CLI cannot accept clipboard images — it requires a file path. The GUI extension supports both.

### `ahks/clip_capture_smartpaste.ahk`

| Item | Description |
|---|---|
| GUI paste | `Ctrl+V` — image (standard behavior) |
| CLI paste | `Ctrl+Alt+V` — file path |

Watches for any image arriving on the clipboard (screen capture, browser copy, etc.), automatically saves it as PNG to TEMP, and stores the path internally.

1. Capture or copy any image → image lands on clipboard
2. AHK automatically saves PNG to TEMP + stores path internally
3. **`Ctrl+V`** → paste image in GUI (standard OS behavior, AHK does not intercept)
4. **`Ctrl+Alt+V`** → paste file path in CLI

#### Changing the hotkey

If `Ctrl+Alt+V` conflicts with another app, change the `^!v::` line in the script.

| Symbol | Key |
|---|---|
| `^` | Ctrl |
| `!` | Alt |
| `+` | Shift |
| `#` | Win |

```ahk
^!v::   ; Ctrl+Alt+V  (default)
^+v::   ; Ctrl+Shift+V
#v::    ; Win+V
^!+v::  ; Ctrl+Alt+Shift+V
```

---

## Auto-start

Place a shortcut to the `.ahk` file in the Windows startup folder:

```text
Win+R → shell:startup
```

## License

AutoHotkey v2 is licensed under GNU GPL v2. Scripts in this repo are free to use for personal and commercial purposes.
