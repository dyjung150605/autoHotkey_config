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

Pastes the path of a captured image or a copied file. **Images come from PicPick's auto-save folder** (AHK does not save them itself).

| Item | Description |
|---|---|
| GUI paste | `Ctrl+V` — image/text (standard OS behavior) |
| CLI paste | `Ctrl+Alt+V` — path (whichever capture/copy is more recent) |

- **Image**: uses the **newest PNG** in PicPick's auto-save folder (`CAPTURE_DIR`, default `D:\_captures`).
- **File** (Explorer copy): stores the clipboard file path.
- **Text**: ignored.

`Ctrl+Alt+V` pastes **whichever you did more recently** — image capture or file copy. It checks the file exists first and shows a 1.5s tooltip of what was pasted (warns if none).

> **Prerequisite:** PicPick auto-save must be on and pointed at `CAPTURE_DIR`. Using a different capture tool? Just change `CAPTURE_DIR` to its folder.

---

#### Settings

Change only the two values at the top of the script.

- `PATH_PASTE_HOTKEY` — paste hotkey (see symbols below)
- `CAPTURE_DIR` — capture image folder (default `D:\_captures`)

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
