# AutoHotkey Config

[English](README.md) | **한국어**

Windows CLI 환경(Claude Code 등)에서 클립보드 이미지 붙여넣기가 불가능한 문제를 해결하기 위한 AutoHotkey v2 스크립트 모음입니다.

화면을 캡처하고, 이미지를 파일로 저장한 뒤, **파일 경로**를 클립보드에 복사하여 CLI에서 바로 붙여넣을 수 있게 합니다.

## 요구사항

- [AutoHotkey v2](https://www.autohotkey.com/)
- Windows 10/11

## 스크립트

### `ahks/clip_capture_wintcap_temp.ahk`

| 항목 | 설명 |
|---|---|
| 단축키 | `Ctrl+Alt+C` |
| 캡처 도구 | Windows 캡처 도구 (`ms-screenclip:`) |
| 저장 위치 | `TEMP` 폴더 (기본) / `SAVE_DIR` 설정 가능 |

Windows 캡처 도구로 영역 캡처 → TEMP 폴더에 PNG 저장 → 경로 클립보드 복사

### `ahks/clip_capture_wincap_dir.ahk`

| 항목 | 설명 |
|---|---|
| 단축키 | `Ctrl+Alt+C` |
| 캡처 도구 | Windows 캡처 도구 (`ms-screenclip:`) |
| 저장 위치 | 사용자 지정 `SAVE_DIR` |

위와 동일하나, 사용자가 지정한 폴더에 저장합니다.

> **주의:** `wintcap_temp`와 단축키가 동일하므로 둘 중 하나만 실행할 것.

### `ahks/clip_capture_pickcap_dir.ahk`

| 항목 | 설명 |
|---|---|
| 단축키 | `Shift+F7` (변경 가능) |
| 캡처 도구 | [PickPick](https://picpick.app/) (써드파티) |
| 저장 위치 | `TEMP` 폴더 |

PickPick 영역 캡처 연동 → 클립보드 이미지를 TEMP에 독립 저장 → 경로 클립보드 복사. PickPick 자동저장 경로와 무관하게 동작합니다.

> **참고:** `Shift+F7`은 작성자의 PickPick 단축키 설정 기준입니다. 스크립트 내 `~+F7` 부분을 본인의 PickPick 단축키에 맞게 변경하세요.

> `wintcap_temp` 또는 `wincap_dir`과 동시 실행 가능 (단축키 충돌 없음).

## 사용법

1. `.ahk` 파일 실행 (설치 시 더블클릭, 포터블은 `AutoHotkey.exe`에 드래그앤드롭)
2. 단축키 입력 → 캡처 영역 선택
3. 저장된 이미지의 파일 경로가 클립보드에 복사됨
4. Claude Code CLI에서 `Ctrl+V`로 경로 붙여넣기

## 자동 실행

시작프로그램 폴더에 `.ahk` 바로가기를 넣으면 부팅 시 자동 실행:

```
Win+R → shell:startup
```

## 라이선스

AutoHotkey v2는 GNU GPL v2 라이선스입니다. 이 저장소의 스크립트는 개인 및 상업적 용도로 자유롭게 사용 가능합니다.
