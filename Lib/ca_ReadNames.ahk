#Requires AutoHotkey v2.0
#Include OCR.ahk
#Include Gdip_All.ahk


ca_ReadNames() {
    WinActivate "ahk_exe Zoom.exe"
    WinWaitActive "ahk_exe Zoom.exe"

    names := []
    currentPos := 70
    loop {
        loop 20 {
            ; dbg
            MouseMove 1653, currentPos
            ; old code
            ; capture screen
            ; pBitmap := Gdip_BitmapFromScreen(1653 . "|" . currentPos . "|200|38")
            ; Gdip_SaveBitmapToFile(pBitmap, "test/" . A_Index . ".png")
            ; hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap)
            ; convert to text
            ; text := OCR.FromBitmap(hBitmap)
            ; names.push(text.Text)
            ; Gdip_DisposeImage(pBitmap)
            ; DeleteObject(hBitmap)
            text := OCR.FromRect(1653, currentPos, 200, 38)
            names.push(text.Text)
            currentPos += 40
        }
        ; scroll down
        Click "WheelDown" 20
        currentPos := 70
    }
    return names
}