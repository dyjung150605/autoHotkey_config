; ============================================================
; clip_capture_smartpaste.ahk — 캡처 이미지 / 복사 파일 → 경로 붙여넣기
; 동작:
;   - 이미지   : PicPick 자동저장 폴더(CAPTURE_DIR)의 "가장 최근 PNG" 경로를 사용
;                (AHK가 직접 저장하지 않음 — PicPick이 D:\_captures에 저장)
;   - 파일복사 : 탐색기에서 파일 복사 시 그 경로를 보관
;   - 둘 중 "더 최근에 한 것"을 Ctrl+Alt+V로 경로 붙여넣기
;   - 텍스트   : 무시 (Ctrl+V 정상 동작)
; 단축키:
;   Ctrl+V           : 기본 붙여넣기 (OS 동작, AHK 미개입)
;   PATH_PASTE_HOTKEY: 보관/탐지된 경로 붙여넣기 (CLI용)
;
; [설정] 아래 PATH_PASTE_HOTKEY / CAPTURE_DIR 값만 수정하세요.
;   기호: ^ = Ctrl  ! = Alt  + = Shift  # = Win
;   예시: "^!v" = Ctrl+Alt+V / "^+v" = Ctrl+Shift+V / "#v" = Win+V
; ============================================================

#Requires AutoHotkey v2.0

; ===== 설정 =====
PATH_PASTE_HOTKEY := "^!v"            ; 경로 붙여넣기 단축키
CAPTURE_DIR       := "D:\_captures"   ; PicPick 자동저장 폴더 (이미지 PNG)

; ===== 상태 =====
capturedFilePath := ""               ; 탐색기에서 복사한 파일 경로
capturedFileTime := ""               ; 그 복사 시각 (YYYYMMDDHHMISS)
selfChange       := false            ; 스크립트가 만든 클립보드 변경 무시 플래그

Hotkey PATH_PASTE_HOTKEY, PastePath
OnClipboardChange ClipChanged

; 탐색기 "파일 복사"만 추적 (이미지는 PicPick 폴더에서 직접 읽으므로 감시 불필요)
ClipChanged(type) {
    global capturedFilePath, capturedFileTime, selfChange
    if selfChange {                  ; 우리가 바꾼 변경이면 무시
        selfChange := false
        return
    }
    if type = 1 {                    ; 1 = 텍스트/파일경로
        p := Trim(A_Clipboard)
        if FileExist(p) {            ; 실제 존재하는 파일이면 = 탐색기 복사
            capturedFilePath := p
            capturedFileTime := A_Now
        }
        ; 일반 텍스트는 무시
    }
}

PastePath(*) {
    global capturedFilePath, capturedFileTime, CAPTURE_DIR, selfChange

    ; 1) PicPick 폴더 루트에서 가장 최근 PNG 찾기 (하위 날짜폴더는 제외)
    imgPath := "", imgTime := ""
    loop files CAPTURE_DIR "\*.png" {
        if (imgTime = "" || A_LoopFileTimeModified > imgTime) {
            imgTime := A_LoopFileTimeModified
            imgPath := A_LoopFileFullPath
        }
    }

    ; 2) 이미지 vs 파일복사 중 "더 최근" 선택
    target := ""
    if (imgPath != "" && capturedFilePath != "")
        target := (imgTime > capturedFileTime) ? imgPath : capturedFilePath
    else if (imgPath != "")
        target := imgPath
    else if (capturedFilePath != "")
        target := capturedFilePath

    ; 3) 검증 후 붙여넣기
    if (target = "" || !FileExist(target)) {
        Notify("붙일 캡처/파일이 없습니다")
        return
    }
    selfChange := true
    A_Clipboard := target
    Sleep 50
    Send "^v"
    Notify("붙임: " target)
}

Notify(msg) {
    ToolTip msg
    SetTimer () => ToolTip(), -1500   ; 1.5초 후 자동 사라짐
}
