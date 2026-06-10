; ============================================================
; clip_capture_shiftF7.ahk — 화면 캡처 → 이미지 저장 → 경로 클립보드 복사
; 단축키: Ctrl+Alt+C
; 용도: Claude Code CLI에 이미지 경로를 바로 붙여넣기 위함
; ============================================================

; --- [설정] 저장 경로 ---
; 원하는 폴더 경로로 변경 (백슬래시 없이 끝낼 것)
SAVE_DIR := "D:"

^!c:: {  ; Ctrl+Alt+C

    ; --- 클립보드 비우기 (이전 데이터가 남아있으면 ClipWait이 즉시 통과하므로) ---
    A_Clipboard := ""

    ; --- 캡처 도구를 URI로 직접 실행 ---
    Run "ms-screenclip:"

    ; --- 새 이미지가 클립보드에 들어올 때까지 대기 (최대 60초) ---
    if !ClipWait(60, 1) {
        MsgBox "캡처가 취소되었거나 시간 초과"
        return
    }

    ; --- 클립보드 안정화 대기 ---
    Sleep 1000

    ; --- PowerShell: 클립보드 이미지 → PNG 저장 → 경로를 클립보드에 복사 ---
    psCmd := 'Add-Type -AssemblyName System.Windows.Forms;'
        . '$img = [System.Windows.Forms.Clipboard]::GetImage();'
        . 'if ($img) {'
        . '  $p = \"' . SAVE_DIR . '\clip_\" + (Get-Date -Format \"yyyyMMdd_HHmmss\") + \".png\";'
        . '  $img.Save($p);'
        . '  [System.Windows.Forms.Clipboard]::SetText($p)'
        . '}'

    Run 'powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -Command "' . psCmd . '"',, "Hide"
}
