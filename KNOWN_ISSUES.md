# Known Issues — clip_capture_smartpaste

`clip_capture_smartpaste.ahk`(및 `old/`로 정리된 smartimagepaste)의 알려진 문제와 개선 후보 정리.
작성 2026-06-11.

## 동작 전제 (요약)

- **이미지**: `Ctrl+Alt+V` 시점에 PicPick 자동저장 폴더(`CAPTURE_DIR`)에서 가장 최근 이미지 파일을 탐색.
- **파일·폴더 복사**: 탐색기 Ctrl+C(CF_HDROP), "경로로 복사"(Shift+우클릭), 주소창 복사 등으로 클립보드에 올라온 경로를 `capturedFilePath`에 보관.
- `Ctrl+V`: OS 기본(이미지·텍스트 그대로). `Ctrl+Alt+V`: 이미지 vs 파일/폴더 경로 중 **더 최근에 한 것** 경로를 붙여넣기 → CLI에 경로 입력.

---

## 1. [보류] Ctrl+Alt+V가 클립보드 이미지를 경로로 덮어씀

- **현상**: `Ctrl+Alt+V`는 `A_Clipboard := target`으로 클립보드를 경로 텍스트로 교체. 그 직후엔 같은 이미지를 `Ctrl+V`로 못 붙임(이미 경로로 덮임).
- **부수효과**: 클립보드 이력(클립보드 매니저)에 경로 항목이 끼어듦.
- **상태**: **의도적으로 보류.** 현행 방식 그대로 사용하기로 결정(2026-06-11). 추후 재검토.
- 코드: `PastePath()` 의 `A_Clipboard := target; Send "^v"`

---

## 2. [해결 2026-06-11] stale·dead 경로를 검증 없이 붙여넣음

> **해결:** 이미지 소스를 `%TEMP%` 재저장 → **PicPick 자동저장 폴더(`D:\_captures`)의 최신 이미지**로 전환.
> `Ctrl+Alt+V` 시점에 최신 파일을 탐색하고 `FileExist`로 검증, 무엇을 붙였는지 툴팁 표시.
> PowerShell 재저장을 제거해 저장실패·레이스도 함께 소멸. (이미지·파일복사 중 더 최근 것을 붙임)

**증상 (Claude Code 사용 중 관측):**

- "이미지가 없다"고 함 → 붙인 경로의 PNG가 이미 삭제된 상태.
- 이미지가 없는데도 있는 것처럼 가정/헛소리 → 붙인 경로가 **이전(엉뚱한) 이미지**를 가리킴.

**한 뿌리:** `capturedPath`가 최신·유효함을 보장하지 않음.

세부 원인:

1. **저장 실패 시 옛 경로 유지** — PowerShell 저장 실패 시 `pathFile` 미생성 → `capturedPath`가 직전 값 유지(else 분기 없음).
2. **붙여넣기 시 파일 존재 미확인** — `PastePath`는 `capturedPath != ""`만 검사, `FileExist`는 안 봄. TEMP 청소로 파일이 사라져도 죽은 경로를 붙임.
3. **빠른 붙여넣기 레이스** — 캡처 직후 저장(수백 ms) 완료 전에 `Ctrl+Alt+V`를 누르면 갱신 전 옛 경로가 붙음.
4. **TEMP 휘발성** — `%TEMP%` PNG가 Windows 청소(Storage Sense 등)로 삭제될 수 있음.

**개선 방향 (적용 결과):**

- [x] `Ctrl+Alt+V` 시 `FileExist` 확인, 없으면 붙이지 않고 툴팁 경고
- [x] stale 차단 — 보관 변수 대신 **붙임 시점에 최신 파일을 탐색**(항상 최신, stale 변수 자체가 없음)
- [x] 레이스 방지 — PowerShell 재저장 제거로 저장-대기 구간 소멸
- [x] 저장 위치 `%TEMP%` → PicPick 전용 폴더(`D:\_captures`) → OS 청소 회피
- [x] 붙임 시 툴팁 1줄로 무엇을 붙였는지 시각 확인

---

## 3. [해소 2026-06-11] 동일 초 캡처 시 파일명 충돌

- (구) AHK가 `clip_yyyyMMdd_HHmmss.png`(초 해상도)로 저장 → 같은 1초 두 번 캡처 시 파일명 충돌.
- 2번 해결로 AHK가 더 이상 파일을 저장하지 않음(PicPick이 파일명 관리). 최신 선택은 파일 수정시각(mtime) 기준이라 충돌 영향 없음. → 해소.

---

## 4. [해결 2026-06-11] 파일·폴더 경로 캡처 미동작

> **해결:** CF_HDROP 직접 추출(DragQueryFileW), 따옴표 제거, 폴더 전역 차단 해제.

**증상:** 탐색기에서 파일/폴더를 복사해도 `Ctrl+Alt+V` 시 항상 이미지 경로만 붙음.

세부 원인:

1. **탐색기 Ctrl+C (CF_HDROP)** — `A_Clipboard`가 CF_HDROP 포맷 텍스트를 반환하지 않아 `capturedFilePath` 미설정.
2. **"경로로 복사" (Shift+우클릭)** — 큰따옴표 포함 텍스트(`"D:\..."`)로 `FileExist` 실패.
3. **폴더 경로 전역 차단** — `FileExist` 반환값에 `"D"` 포함 시 무조건 제외 → 폴더 복사도 불가.

**적용 결과:**

- [x] CF_HDROP → `DragQueryFileW` DllCall로 단일 파일/폴더 경로 추출
- [x] 큰따옴표 양쪽 제거 후 `FileExist` 검사
- [x] 폴더 포함 경로는 허용 (이미지 탐색은 `*.확장자` 패턴으로 자동 제외)

---

## 5. [해결 2026-06-11] 이미지 탐색 PNG 한정

> **해결:** `loop files *.png` → `loop files *.*` + `RegExMatch` 확장자 필터.

**증상:** PicPick에서 PNG 외 포맷(JPG, BMP, GIF, WebP, PDF)으로 저장 시 `Ctrl+Alt+V`에서 감지 안 됨.

**지원 확장자 (현재):** `png · jpg · jpeg · bmp · gif · tif · tiff · webp · pdf`

---

## 메모

- 재현 패턴을 기록해두면 정밀 수정에 도움: 깨질 때가 "빠른 붙여넣기 직후"인지 "시간 지난 뒤"인지 구분.
