; ============================================================
; clip_capture_pickcap_dir.ahk — PickPick 캡처 연동 → TEMP 저장 → 경로 클립보드 복사
; 단축키: Ctrl+Alt+PrtSc (PickPick 기본값: 지정 영역 캡처)
; 동작: Ctrl+Alt+PrtSc → PickPick 영역캡처 (키 통과) → 클립보드 이미지를 TEMP에 저장 → 경로 클립보드 복사
; 용도: Claude Code CLI에 이미지 경로를 바로 붙여넣기 위함
; 비고: PickPick 자동저장 경로와 무관하게 독립 동작
; ============================================================

; --- [설정] 단축키 ---
; Ctrl+Alt+PrtSc는 PickPick 배포판 기본값 (지정 영역 캡처)입니다.
; PickPick에서 다른 단축키를 사용 중이라면 아래 ~^!PrintScreen 부분을 맞춰 변경하세요.
; 예: Shift+F7 → ~+F7, Ctrl+Shift+C → ~^+c
; ~ 접두사: 키를 가로채지 않고 PickPick에도 그대로 전달
~^!PrintScreen:: {

    ; --- 클립보드 비우기 ---
    A_Clipboard := ""

    ; --- PickPick 캡처 완료 대기 (최대 60초, 클립보드에 이미지 들어올 때까지) ---
    if !ClipWait(60, 1) {
        MsgBox "캡처가 취소되었거나 시간 초과"
        return
    }

    ; --- 클립보드 안정화 대기 ---
    Sleep 1000

    ; --- PowerShell: 클립보드 이미지 → TEMP에 PNG 저장 → 경로를 클립보드에 복사 ---
    psCmd := 'Add-Type -AssemblyName System.Windows.Forms;'
        . '$img = [System.Windows.Forms.Clipboard]::GetImage();'
        . 'if ($img) {'
        . '  $p = $env:TEMP + \"\clip_\" + (Get-Date -Format \"yyyyMMdd_HHmmss\") + \".png\";'
        . '  $img.Save($p);'
        . '  [System.Windows.Forms.Clipboard]::SetText($p)'
        . '}'

    Run 'powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -Command "' . psCmd . '"',, "Hide"
}
