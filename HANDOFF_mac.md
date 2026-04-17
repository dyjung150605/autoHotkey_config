# Mac 이식 검토 — Handoff 메모

Windows에서 구현한 스마트 붙여넣기 흐름을 Mac에도 적용하기 위한 검토 사항.

---

## Windows 현재 흐름 (참고용)

| 단축키 | 동작 |
|---|---|
| `Win+Shift+F7` | PickPick 영역캡처 → 이미지 클립보드 유지 + 경로 AHK 내부 저장 |
| `Ctrl+V` | GUI(Claude Code 패널)에서 이미지 붙여넣기 |
| `Ctrl+Alt+V` | CLI(통합 터미널)에서 경로 붙여넣기 |

핵심: **캡처 시 항상 파일로 저장** → GUI는 이미지, CLI는 경로를 각각 붙여넣기 가능.

---

## Mac 현재 상황

- `Shift+F7` → 이미지를 클립보드에만 저장 (파일 저장 X)
- `Shift+F8` → 이미지를 파일로 저장 + 경로를 클립보드에 복사

**문제:** Shift+F7은 파일이 안 남아서 나중에 이력을 찾을 수 없음.

---

## 확인이 필요한 것

### 1. 단축키를 처리하는 앱이 무엇인가?

아래 순서로 확인:

1. `시스템 설정 → 키보드 → 단축키 → 스크린샷` — 여기에 Shift+F7/F8 등록 여부
2. Karabiner-Elements 실행 여부 확인
3. 기타 캡처 앱 (CleanShot X, Shottr, Monosnap 등) 실행 여부

### 2. 파일 저장 위치

Shift+F8로 저장된 파일이 어디에 저장되는지 확인 (Desktop? 지정 폴더?).

---

## 목표 흐름 (Windows와 동일하게)

캡처 시 **항상 파일로 저장**하고:
- GUI(Claude Code 패널): 그냥 붙여넣기 → 이미지
- CLI(터미널): 별도 단축키 → 경로

---

## 구현 방향 (앱에 따라 결정)

| 상황 | 추천 방법 |
|---|---|
| Mac 기본 스크린샷 앱 사용 중 | Hammerspoon으로 단축키 감지 후 파일 저장 + 경로 저장 |
| CleanShot X / Shottr 사용 중 | 앱 자체 자동저장 활용 + Hammerspoon으로 경로 단축키 추가 |
| 툴 미확정 | CleanShot X 또는 Shottr 도입 검토 (PickPick 역할) |

Hammerspoon은 Mac에서 AHK와 가장 유사한 무료 자동화 도구.
