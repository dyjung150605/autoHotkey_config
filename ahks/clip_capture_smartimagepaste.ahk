; ============================================================
; clip_capture_smartpaste.ahk — 클립보드 이미지 자동 저장 + 스마트 붙여넣기
; 동작:
;   클립보드에 이미지가 올라오면 (캡처 도구, 브라우저 복사 등 모든 경우)
;   자동으로 TEMP에 PNG 저장 + 경로 내부 보관
; 단축키:
;   Ctrl+V     : 이미지 붙여넣기 (GUI용 — OS 기본 동작, AHK 미개입)
;   Ctrl+Alt+V : 저장된 경로 붙여넣기 (CLI용 — 아래에서 변경 가능)
;
; [경로 붙여넣기 단축키 변경 방법]
;   아래 ^!v:: 부분을 원하는 조합으로 바꾸세요.
;   기호 조합:
;     ^  = Ctrl
;     !  = Alt
;     +  = Shift
;     #  = Win
;   예시:
;     ^!v::   → Ctrl+Alt+V  (기본값)
;     ^+v::   → Ctrl+Shift+V
;     #v::    → Win+V
;     ^!+v::  → Ctrl+Alt+Shift+V
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
        . "Add-Type -AssemblyName System.Drawing`r`n"
        . "try {`r`n"
        . "  $data = [System.Windows.Forms.Clipboard]::GetDataObject()`r`n"
        . "  $img = $null`r`n"
        . "  if ($data.GetDataPresent('PNG')) {`r`n"
        . "    $stream = $data.GetData('PNG')`r`n"
        . "    $img = [System.Drawing.Image]::FromStream($stream)`r`n"
        . "  } elseif ($data.GetDataPresent([System.Windows.Forms.DataFormats]::Bitmap)) {`r`n"
        . "    $img = $data.GetData([System.Windows.Forms.DataFormats]::Bitmap)`r`n"
        . "  }`r`n"
        . "  if ($img) {`r`n"
        . "    $p = $env:TEMP + '\clip_' + (Get-Date -Format 'yyyyMMdd_HHmmss') + '.png'`r`n"
        . "    $img.Save($p, [System.Drawing.Imaging.ImageFormat]::Png)`r`n"
        . "    [System.IO.File]::WriteAllText('" . pathFile . "', $p)`r`n"
        . "  }`r`n"
        . "} catch { Write-Error $_.Exception.Message }"
    FileAppend psContent, psFile
    RunWait 'powershell.exe -STA -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File "' . psFile . '"',, "Hide"
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
