; ============================================================
; clip_capture_smartpaste.ahk — Win+Shift+F7로 PickPick 캡처 → 스마트 붙여넣기
; 단축키:
;   Win+Shift+F7 : PickPick 영역캡처 → 이미지 클립보드 유지 + 경로 내부 저장
;   Ctrl+Alt+V   : 저장된 경로 붙여넣기 (CLI용)
; 동작:
;   - GUI (Claude Code 패널) : 그냥 Ctrl+V → 이미지 붙여넣기
;   - CLI (통합 터미널)      : Ctrl+Alt+V → 경로 붙여넣기
; ============================================================

#Requires AutoHotkey v2.0

capturedPath := ""

#+F7:: {  ; Win+Shift+F7
    global capturedPath
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

        ; --- Win 키 해제 대기 ---
        KeyWait "LWin"
        KeyWait "RWin"
        Sleep 100

        ; --- 클립보드 비우기 후 PickPick 캡처 호출 ---
        A_Clipboard := ""
        Send "+{F7}"

        ; --- 캡처 완료 대기 (최대 30초) ---
        if !ClipWait(30, 1)
            return

        Sleep 500

        ; --- 임시 PS1: 이미지 저장 후 경로를 파일에 기록 (클립보드는 이미지 그대로 유지) ---
        pathFile := A_Temp . "\clip_path_" . A_TickCount . ".txt"
        psFile   := A_Temp . "\clip_save_" . A_TickCount . ".ps1"
        psContent := "Add-Type -AssemblyName System.Windows.Forms`r`n"
            . "$img = [System.Windows.Forms.Clipboard]::GetImage()`r`n"
            . "if ($img) {`r`n"
            . "  $p = $env:TEMP + '\clip_' + (Get-Date -Format 'yyyyMMdd_HHmmss') + '.png'`r`n"
            . "  $img.Save($p)`r`n"
            . "  [System.IO.File]::WriteAllText('" . pathFile . "', $p)`r`n"
            . "}"
        FileAppend psContent, psFile
        RunWait 'powershell.exe -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File "' . psFile . '"',, "Hide"
        FileDelete psFile

        ; --- 경로 읽어서 변수에 저장 ---
        if FileExist(pathFile) {
            capturedPath := FileRead(pathFile)
            FileDelete pathFile
        }
    } finally {
        running := false
    }
}

^!v:: {  ; Ctrl+Alt+V — 저장된 경로 붙여넣기 (CLI용)
    global capturedPath
    if capturedPath = ""
        return
    A_Clipboard := capturedPath
    Sleep 50
    Send "^v"
}
