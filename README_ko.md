# AutoHotkey Config

[English](README.md) | **한국어**

Windows 워크플로우 자동화를 위한 AutoHotkey v2 스크립트 모음입니다.

## 요구사항

- [AutoHotkey v2](https://www.autohotkey.com/)
- Windows 10/11

---

## 1. 클립보드 → 스마트 붙여넣기

Claude Code처럼 CLI와 GUI를 함께 쓰는 환경에서 이미지/파일 붙여넣기 방식을 분리합니다.

**배경:** Claude Code CLI는 클립보드 이미지를 직접 붙여넣을 수 없고 파일 경로만 허용합니다. GUI(확장프로그램)는 이미지/경로 모두 지원합니다.

---

### `ahks/clip_capture_smartpaste.ahk` ✨ 권장

이미지와 파일 경로를 모두 감지합니다.

| 항목 | 설명 |
|---|---|
| GUI 붙여넣기 | `Ctrl+V` — 이미지/텍스트 (OS 기본 동작) |
| CLI 붙여넣기 | `Ctrl+Alt+V` — 파일 경로 |

클립보드 변화를 자동 감지:
- **이미지**: TEMP에 PNG로 저장 후 경로 보관
- **파일** (탐색기 복사 등): 경로 그대로 보관
- **텍스트**: 무시

1. 이미지 캡처 또는 파일 복사 → 클립보드에 올라옴
2. AHK가 자동으로 경로 보관
3. **`Ctrl+V`** → GUI에서 이미지 붙여넣기
4. **`Ctrl+Alt+V`** → CLI에서 경로 붙여넣기

---

### `ahks/clip_capture_smartimagepaste.ahk`

이미지만 감지하는 이전 버전입니다. 파일 경로 감지가 필요 없다면 이쪽이 더 단순합니다.

| 항목 | 설명 |
|---|---|
| GUI 붙여넣기 | `Ctrl+V` — 이미지 (OS 기본 동작) |
| CLI 붙여넣기 | `Ctrl+Alt+V` — 저장된 이미지 경로 |

---

#### 단축키 변경

두 스크립트 모두 상단의 `PATH_PASTE_HOTKEY` 값만 바꾸면 됩니다.

| 기호 | 키 |
|---|---|
| `^` | Ctrl |
| `!` | Alt |
| `+` | Shift |
| `#` | Win |

```ahk
PATH_PASTE_HOTKEY := "^!v"   ; Ctrl+Alt+V  (기본값)
PATH_PASTE_HOTKEY := "^+v"   ; Ctrl+Shift+V
PATH_PASTE_HOTKEY := "#v"    ; Win+V
PATH_PASTE_HOTKEY := "^!+v"  ; Ctrl+Alt+Shift+V
```

---

## 자동 실행

시작프로그램 폴더에 `.ahk` 바로가기를 넣으면 부팅 시 자동 실행:

```text
Win+R → shell:startup
```

## 라이선스

AutoHotkey v2는 GNU GPL v2 라이선스입니다. 이 저장소의 스크립트는 개인 및 상업적 용도로 자유롭게 사용 가능합니다.
