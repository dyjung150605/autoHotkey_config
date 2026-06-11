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

캡처 이미지와 복사한 파일 경로를 붙여넣습니다. **이미지는 PicPick 자동저장 폴더를 사용합니다** (AHK가 직접 저장하지 않음).

| 항목 | 설명 |
|---|---|
| GUI 붙여넣기 | `Ctrl+V` — 이미지/텍스트 (OS 기본 동작) |
| CLI 붙여넣기 | `Ctrl+Alt+V` — 경로 (더 최근에 한 캡처/복사) |

- **이미지**: PicPick 자동저장 폴더(`CAPTURE_DIR`, 기본 `D:\_captures`)의 **가장 최근 PNG** 경로 사용.
- **파일** (탐색기 복사): 클립보드의 파일 경로 보관.
- **텍스트**: 무시.

`Ctrl+Alt+V`는 **이미지·파일복사 중 더 최근에 한 것**을 붙입니다. 붙이기 직전 파일 존재를 확인하고, 무엇을 붙였는지 툴팁으로 1.5초간 표시합니다(없으면 경고).

> **전제:** PicPick 자동저장이 켜져 있고 `CAPTURE_DIR` 폴더로 저장되어야 합니다. 다른 캡처 도구를 쓰면 `CAPTURE_DIR`만 그 폴더로 바꾸세요.

---

#### 설정

스크립트 상단의 두 값만 바꾸면 됩니다.

- `PATH_PASTE_HOTKEY` — 경로 붙여넣기 단축키 (아래 기호 참고)
- `CAPTURE_DIR` — 캡처 이미지 폴더 (기본 `D:\_captures`)

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
