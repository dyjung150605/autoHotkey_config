; ============================================================
; clip_capture_smartpaste.ahk — 클립보드 이미지 감지 → 스마트 붙여넣기
; 동작:
;   Shift+F7 (PickPick 직접) → 캡처 → 클립보드 이미지 자동 감지
;   → TEMP에 PNG 저장 + 경로 내부 보관
;   Ctrl+Alt+V : 저장된 경로 붙여넣기 (CLI용)
;   Ctrl+V     : 이미지 그대로 붙여넣기 (GUI용)
; ============================================================

#Requires AutoHotkey v2.0

capturedPath := ""
LOG_FILE := "D:\DYCODE\003_AUTOHOTKEY\ahks\debug.log"

Log(msg) {
    global LOG_FILE
    FileAppend FormatTime(, "yyyy-MM-dd HH:mm:ss") . " " . msg . "`n", LOG_FILE
}

OnClipboardChange ClipChanged

ClipChanged(type) {
    global capturedPath
    if type != 2  ; 2 = 이미지
        return

    Log("[CLIP] 클립보드 이미지 감지, 저장 중...")

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

    if FileExist(pathFile) {
        capturedPath := FileRead(pathFile)
        FileDelete pathFile
        Log("[OK] path saved: " . capturedPath)
    } else {
        Log("[FAIL] PS1이 파일을 생성하지 못함")
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
