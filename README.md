# AutoHotkey Config

Personal AutoHotkey v2 scripts for screen capture workflow automation on Windows.

These scripts bridge the gap where Windows CLI tools (like Claude Code) cannot accept clipboard images directly — instead, they capture the screen, save the image to a file, and copy the **file path** to the clipboard for easy pasting.

---

Windows CLI 환경(Claude Code 등)에서 클립보드 이미지 붙여넣기가 불가능한 문제를 해결하기 위한 AutoHotkey v2 스크립트 모음입니다.

화면을 캡처하고, 이미지를 파일로 저장한 뒤, **파일 경로**를 클립보드에 복사하여 CLI에서 바로 붙여넣을 수 있게 합니다.

## Requirements / 요구사항

- [AutoHotkey v2](https://www.autohotkey.com/) (portable or installed)
- Windows 10/11

## Scripts / 스크립트

### `ahks/clip_capture_wintcap_temp.ahk`

| Item | Description |
|---|---|
| Hotkey | `Ctrl+Alt+C` |
| Capture tool | Windows Snipping Tool (`ms-screenclip:`) |
| Save location | `TEMP` folder (default) / custom `SAVE_DIR` |

Windows 캡처 도구로 영역 캡처 → TEMP 폴더에 PNG 저장 → 경로 클립보드 복사

### `ahks/clip_capture_wincap_dir.ahk`

| Item | Description |
|---|---|
| Hotkey | `Ctrl+Alt+C` |
| Capture tool | Windows Snipping Tool (`ms-screenclip:`) |
| Save location | Custom `SAVE_DIR` (configurable) |

Windows 캡처 도구로 영역 캡처 → 지정 폴더에 PNG 저장 → 경로 클립보드 복사

> **Note:** Shares the same hotkey as `wintcap_temp`. Run only one of the two.
>
> `wintcap_temp`와 단축키가 동일하므로 둘 중 하나만 실행할 것.

### `ahks/clip_capture_pickcap_dir.ahk`

| Item | Description |
|---|---|
| Hotkey | `Shift+F7` |
| Capture tool | [PickPick](https://picpick.app/) (third-party) |
| Save location | PickPick auto-save directory |

PickPick 영역 캡처 연동 → PickPick 자동저장 폴더에서 최신 파일 감지 → 경로 클립보드 복사

> Can run simultaneously with either `wintcap_temp` or `wincap_dir` (no hotkey conflict).
>
> `wintcap_temp` 또는 `wincap_dir`과 동시 실행 가능 (단축키 충돌 없음).

## Usage / 사용법

1. Run the `.ahk` script (double-click if installed, or drag onto `AutoHotkey.exe` for portable)

   `.ahk` 파일 실행 (설치 시 더블클릭, 포터블은 `AutoHotkey.exe`에 드래그앤드롭)

2. Press the assigned hotkey → select capture area

   단축키 입력 → 캡처 영역 선택

3. The saved image's file path is now in your clipboard

   저장된 이미지의 파일 경로가 클립보드에 복사됨

4. Paste (`Ctrl+V`) the path in Claude Code CLI

   Claude Code CLI에서 `Ctrl+V`로 경로 붙여넣기

## Auto-start / 자동 실행

Place a shortcut to the `.ahk` file in the Windows startup folder:

시작프로그램 폴더에 `.ahk` 바로가기를 넣으면 부팅 시 자동 실행:

```
Win+R → shell:startup
```

## License

AutoHotkey v2 is licensed under GNU GPL v2. Scripts in this repo are free to use for personal and commercial purposes.
