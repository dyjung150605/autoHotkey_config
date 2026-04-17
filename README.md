# AutoHotkey Config

**English** | [한국어](README_ko.md)

A collection of personal AutoHotkey v2 scripts for Windows workflow automation.

## Requirements

- [AutoHotkey v2](https://www.autohotkey.com/)
- Windows 10/11

---

## 1. Clipboard → Smart Paste

For environments where Claude Code CLI and GUI are used side by side.

**Background:** Claude Code CLI cannot accept clipboard images — it requires a file path. The GUI extension supports both.

---

### `ahks/clip_capture_smartpaste.ahk` ✨ Recommended

Detects both images and file paths.

| Item | Description |
|---|---|
| GUI paste | `Ctrl+V` — image/text (standard OS behavior) |
| CLI paste | `Ctrl+Alt+V` — file path |

Watches clipboard automatically:
- **Image**: saves as PNG to TEMP, stores path
- **File** (Explorer copy, etc.): stores path directly
- **Text**: ignored

1. Capture an image or copy a file → lands on clipboard
2. AHK automatically stores the path
3. **`Ctrl+V`** → paste image in GUI
4. **`Ctrl+Alt+V`** → paste file path in CLI

---

### `ahks/clip_capture_smartimagepaste.ahk`

Previous version — detects images only. Simpler if file path detection is not needed.

| Item | Description |
|---|---|
| GUI paste | `Ctrl+V` — image (standard OS behavior) |
| CLI paste | `Ctrl+Alt+V` — saved image path |

---

#### Changing the hotkey

Both scripts use `PATH_PASTE_HOTKEY` at the top — change only that line.

| Symbol | Key |
|---|---|
| `^` | Ctrl |
| `!` | Alt |
| `+` | Shift |
| `#` | Win |

```ahk
PATH_PASTE_HOTKEY := "^!v"   ; Ctrl+Alt+V  (default)
PATH_PASTE_HOTKEY := "^+v"   ; Ctrl+Shift+V
PATH_PASTE_HOTKEY := "#v"    ; Win+V
PATH_PASTE_HOTKEY := "^!+v"  ; Ctrl+Alt+Shift+V
```

---

## Auto-start

Place a shortcut to the `.ahk` file in the Windows startup folder:

```text
Win+R → shell:startup
```

## License

AutoHotkey v2 is licensed under GNU GPL v2. Scripts in this repo are free to use for personal and commercial purposes.
