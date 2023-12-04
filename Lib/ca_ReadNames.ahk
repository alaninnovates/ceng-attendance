#Requires AutoHotkey v2.0
#Include OCR.ahk
#Include Gdip_All.ahk
#include Array.ahk


ca_ReadNames() {
    ; return ["billy", "bob", "joe"]
    WinActivate "ahk_exe Zoom.exe"
    WinWaitActive "ahk_exe Zoom.exe"

    names := []
    currentPos := 70
    loop 1 {
        if (GetKeyState("Enter", "P")) {
            break
        }
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
        MouseClick "left", 1660, 500
        Click "WheelUp" 2000
        currentPos := 70
    }
    MsgBox ca_ArrJoin(names, "`n")
    MsgBox ca_ArrJoin(ca_RemoveDuplicates(names), "`n")
    return ca_RemoveEmpty(ca_RemoveDuplicates(names))
}