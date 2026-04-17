; ============================================================
; clip_capture_smartpaste.ahk — 클립보드 자동 감지 + 스마트 붙여넣기
; 동작:
;   클립보드에 이미지 또는 파일 경로가 올라오면 자동으로 경로를 내부 보관
;   - 이미지  : TEMP에 PNG로 저장 후 경로 보관
;   - 파일    : 클립보드의 경로 그대로 보관
;   - 텍스트  : 무시 (Ctrl+V 정상 동작)
; 단축키:
;   Ctrl+V           : 기본 붙여넣기 (OS 동작, AHK 미개입)
;   PATH_PASTE_HOTKEY: 보관된 경로 붙여넣기 (CLI용, 아래에서 변경)
;
; [단축키 변경] PATH_PASTE_HOTKEY 값만 수정하세요.
;   기호: ^ = Ctrl  ! = Alt  + = Shift  # = Win
;   예시: "^!v" = Ctrl+Alt+V / "^+v" = Ctrl+Shift+V / "#v" = Win+V
; ============================================================

#Requires AutoHotkey v2.0

PATH_PASTE_HOTKEY := "^!v"  ; ← 여기서 단축키 변경

capturedPath := ""
LOG_FILE := "D:\DYCODE\003_AUTOHOTKEY\ahks\debug.log"

Log(msg) {
    global LOG_FILE
    FileAppend FormatTime(, "yyyy-MM-dd HH:mm:ss") . " " . msg . "`n", LOG_FILE
}

Hotkey PATH_PASTE_HOTKEY, PastePath

PastePath(*) {
    global capturedPath
    if capturedPath = ""
        return
    A_Clipboard := capturedPath
    Sleep 50
    Send "^v"
}

OnClipboardChange ClipChanged

ClipChanged(type) {
    global capturedPath

    if type = 2 {
        ; 이미지: TEMP에 PNG 저장 후 경로 보관
        Log("[CLIP] 이미지 감지, 저장 중...")
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
            Log("[OK] image path saved: " . capturedPath)
        } else {
            Log("[FAIL] PS1이 파일을 생성하지 못함")
        }

    } else if type = 1 {
        ; 파일 경로: 클립보드 내용이 실제 파일이면 경로 보관
        path := Trim(A_Clipboard)
        if FileExist(path) {
            capturedPath := path
            Log("[OK] file path saved: " . capturedPath)
        }
        ; 일반 텍스트면 무시
    }
}
