# Known Issues — clip_capture_smartpaste

`clip_capture_smartpaste.ahk`(및 `old/`로 정리된 smartimagepaste)의 알려진 문제와 개선 후보 정리.
작성 2026-06-11.

## 동작 전제 (요약)

- 이미지가 클립보드에 올라오면 PowerShell로 `%TEMP%\clip_<timestamp>.png`에 저장하고, 그 경로를 내부 변수 `capturedPath`에 보관.
- `Ctrl+V`: OS 기본(이미지 그대로). `Ctrl+Alt+V`: `capturedPath`(경로)를 클립보드에 넣고 붙여넣기 → CLI에 경로 입력.

---

## 1. [보류] Ctrl+Alt+V가 클립보드 이미지를 경로로 덮어씀

- **현상**: `Ctrl+Alt+V`는 `A_Clipboard := capturedPath`로 클립보드를 경로 텍스트로 교체. 그 직후엔 같은 이미지를 `Ctrl+V`로 못 붙임(이미 경로로 덮임).
- **부수효과**: 클립보드 이력(클립보드 매니저)에 경로 항목이 끼어듦.
- **상태**: **의도적으로 보류.** 현행 방식 그대로 사용하기로 결정(2026-06-11). 추후 재검토.
- 코드: `PastePath()` 의 `A_Clipboard := capturedPath; Send "^v"`

---

## 2. [개선 후보] stale·dead 경로를 검증 없이 붙여넣음

**증상 (Claude Code 사용 중 관측):**

- "이미지가 없다"고 함 → 붙인 경로의 PNG가 이미 삭제된 상태.
- 이미지가 없는데도 있는 것처럼 가정/헛소리 → 붙인 경로가 **이전(엉뚱한) 이미지**를 가리킴.

**한 뿌리:** `capturedPath`가 최신·유효함을 보장하지 않음.

세부 원인:

1. **저장 실패 시 옛 경로 유지** — PowerShell 저장 실패 시 `pathFile` 미생성 → `capturedPath`가 직전 값 유지(else 분기 없음).
2. **붙여넣기 시 파일 존재 미확인** — `PastePath`는 `capturedPath != ""`만 검사, `FileExist`는 안 봄. TEMP 청소로 파일이 사라져도 죽은 경로를 붙임.
3. **빠른 붙여넣기 레이스** — 캡처 직후 저장(수백 ms) 완료 전에 `Ctrl+Alt+V`를 누르면 갱신 전 옛 경로가 붙음.
4. **TEMP 휘발성** — `%TEMP%` PNG가 Windows 청소(Storage Sense 등)로 삭제될 수 있음.

**개선 방향 (착수 시 결정):**

- [ ] `Ctrl+Alt+V` 시 `FileExist(capturedPath)` 확인, 없으면 붙이지 않고 경고 → 증상 "없는데 붙음" 차단
- [ ] 새 이미지 감지 즉시 `capturedPath` 비우고 저장 성공 시에만 채움 → stale 차단
- [ ] 저장 완료 전 붙여넣기 차단(플래그/`Critical`) → 레이스 방지
- [ ] 저장 위치 `%TEMP%` → 전용 폴더(예: `D:\_captures\clip\`) → OS 청소 회피
- [ ] 저장/붙임 시 툴팁 1줄로 시각 확인

> 우선순위: **2-1(존재확인) + 2-2(stale 차단)** 만으로 증상 대부분 해소 예상.

---

## 3. [minor] 동일 초 캡처 시 파일명 충돌

- 저장 파일명이 `clip_yyyyMMdd_HHmmss.png` (초 단위 해상도). 같은 1초 안에 두 번 캡처하면 동일 파일명 → 뒤가 앞을 덮음.
- 실사용 빈도 낮음. 2번 개선 시 밀리초/틱 추가로 같이 해결 가능.

---

## 메모

- 재현 패턴을 기록해두면 정밀 수정에 도움: 깨질 때가 "빠른 붙여넣기 직후"인지 "시간 지난 뒤"인지 구분.
