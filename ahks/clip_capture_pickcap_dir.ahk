; ============================================================
; clip_capture_pickcap_dir.ahk — PickPick 캡처 연동 → 저장 경로 클립보드 복사
; 단축키: Shift+F7
; 동작: Shift+F7 → PickPick 영역캡처 (키 통과) → PickPick 자동저장 파일 감지 → 경로 클립보드 복사
; 용도: Claude Code CLI에 이미지 경로를 바로 붙여넣기 위함
; ============================================================

; --- [설정] PickPick 자동저장 경로 (백슬래시 없이 끝낼 것) ---
PICKPICK_DIR := "D:\DYCODE\003_AUTOHOTKEY\테스트"

; --- ~ 접두사: 키를 가로채지 않고 PickPick에도 그대로 전달 ---
~+F7:: {

    ; --- 캡처 완료 대기 (최대 60초, 클립보드에 이미지 들어올 때까지) ---
    A_Clipboard := ""
    if !ClipWait(60, 1) {
        MsgBox "캡처가 취소되었거나 시간 초과"
        return
    }

    ; --- PickPick 파일 저장 대기 ---
    Sleep 1500

    ; --- PickPick 저장 폴더에서 가장 최신 png 파일 찾기 ---
    latest := ""
    latestTime := 0
    Loop Files, PICKPICK_DIR . "\*.png" {
        if (A_LoopFileTimeModified > latestTime) {
            latestTime := A_LoopFileTimeModified
            latest := A_LoopFileFullPath
        }
    }

    ; --- 결과 처리 ---
    if (latest = "") {
        MsgBox "저장된 파일을 찾을 수 없습니다: " . PICKPICK_DIR
        return
    }

    ; --- 최신 파일 경로를 클립보드에 복사 ---
    A_Clipboard := latest
}
