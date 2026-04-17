; ============================================================
; clip_capture_pickcap_winshiftF7.ahk — Win+Shift+F7로 PickPick 호출 → TEMP 저장 → 경로 클립보드 복사
; 단축키: Win+Shift+F7
; 동작:
;   1) 사용자가 Win+Shift+F7 입력
;   2) AHK가 Win 키를 뗀 뒤 Shift+F7을 시스템에 전송 → PickPick 영역캡처 발동
;      (작성자의 PickPick 단축키가 Shift+F7로 설정되어 있음)
;   3) PickPick 캡처 완료 → 클립보드 이미지 감지
;   4) 클립보드 이미지를 TEMP에 PNG 저장 → 경로를 클립보드에 복사
; 용도:
;   - 평소엔 PickPick의 Shift+F7만 사용 (단순 캡처)
;   - 경로 복사가 필요할 때만 Win+Shift+F7 사용
;   - 즉, AHK 동작을 사용자가 명시적으로 컨트롤 가능
; ============================================================

#+F7:: {  ; Win+Shift+F7
    static running := false
    if running
        return
    running := true

    try {
        ; --- PickPick 실행 여부 확인 ---
        if !ProcessExist("picpick.exe") {
            MsgBox "PickPick이 실행 중이지 않습니다.", "clip_capture", 0x10
            return
        }

        ; --- Win 키가 떼어질 때까지 대기 (Win 누른 상태에서 Send 시 충돌 방지) ---
        KeyWait "LWin"
        KeyWait "RWin"
        Sleep 100

        ; --- 클립보드 비우기 ---
        A_Clipboard := ""

        ; --- Shift+F7을 시스템에 전송하여 PickPick 영역캡처 호출 ---
        Send "+{F7}"

        ; --- PickPick 캡처 완료 대기 (최대 30초) ---
        if !ClipWait(30, 1)
            return

        ; --- 클립보드 안정화 대기 ---
        Sleep 500

        ; --- 임시 PS1 파일: 클립보드 이미지 → TEMP에 PNG 저장 → 경로를 클립보드에 복사 ---
        psFile := A_Temp . "\clip_save_" . A_TickCount . ".ps1"
        psContent := "Add-Type -AssemblyName System.Windows.Forms`r`n"
            . "$img = [System.Windows.Forms.Clipboard]::GetImage()`r`n"
            . "if ($img) {`r`n"
            . "  $p = $env:TEMP + '\clip_' + (Get-Date -Format 'yyyyMMdd_HHmmss') + '.png'`r`n"
            . "  $img.Save($p)`r`n"
            . "  [System.Windows.Forms.Clipboard]::SetText($p)`r`n"
            . "}"
        FileAppend psContent, psFile
        RunWait 'powershell.exe -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File "' . psFile . '"',, "Hide"
        FileDelete psFile
    } finally {
        running := false
    }
}
