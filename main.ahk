#Requires AutoHotkey v2.0
#SingleInstance Force
#Include Lib\Array.ahk
#Include Lib\ca_ReadNames.ahk

CoordMode "Mouse", "Screen"

ca_Gui := Gui(, "CENG Attendance")

stuList := []
detectedStuList := []
attendanceStuList := []

pasteStuList := ca_Gui.Add("Button", "x10 y10 w100 h30", "Paste Student List")
pasteStuList.OnEvent("Click", pasteStuList_Click)
clearStuList := ca_Gui.Add("Button", "x120 y10 w60 h30", "Reset")
clearStuList.OnEvent("Click", clearStuList_Click)
stuListView := ca_Gui.Add("ListView", "x10 y50 w200 h300", ["ID", "Student Name"])

takeAttendance := ca_Gui.Add("Button", "x220 y10 w100 h30", "Take Attendance")
takeAttendance.OnEvent("Click", takeAttendance_Click)
detectedListView := ca_Gui.Add("ListView", "x220 y50 w200 h300", ["ID", "Detected Student Name"])

ca_Gui.Add("Text", "x430 y30 w100 h30", "Unknown Names:")
unknownListView := ca_Gui.Add("ListView", "x430 y50 w200 h300", ["Student Name"])

exportButton := ca_Gui.Add("Button", "x530 y360 w100 h30", "Export")
exportButton.OnEvent("Click", exportButton_Click)

pasteStuList_Click(*) {
    global stuList
    pastedList := StrSplit(A_Clipboard, "`n")
    for i, stu in pastedList {
        stuList.Push({
            id: A_Index,
            name: stu
        })
    }
    stuListView.Delete()
    for i, stu in stuList {
        stuListView.Add(, stu.id, stu.name)
    }
}

clearStuList_Click(*) {
    global stuList
    stuList := []
    stuListView.Delete()
}

takeAttendance_Click(*) {
    global stuList, detectedStuList
    detectedStuList := ca_ReadNames()
    WinActivate ca_Gui.Hwnd
    detectedListView.Delete()
    unknownNames := []
    for i, stu in detectedStuList {
        ; find student in stuList
        ; lowercase name, split by space, compare first name and last name seperately
        stuName := StrSplit(stu, " ")
        for j, stu2 in stuList {
            stu2Name := StrSplit(stu2.name, " ")
            firstNameEqual := StrLower(stuName[1]) = StrLower(stu2Name[1])
            lastNameEqual := false
            if (stuName.Length > 1 && stu2Name.Length > 1) {
                lastNameEqual := StrLower(stuName[2]) = StrLower(stu2Name[2])
            }
            if (firstNameEqual) {
                attendanceStuList.Push(stu2.name)
                detectedListView.Add(, stu2.id, stu2.name)
                break
            } else if (j = stuList.Length - 1) {
                unknownNames.Push(stu)
            }
        }
    }
    if (unknownNames.Length > 0) {
        for i, stu in unknownNames {
            unknownListView.Add(, stu)
        }
        unknownListView.OnEvent("DoubleClick", processUnknownName_Click)
        processUnknownName_Click(_, info) {
            selected := showSelectGui()
            unknownNames.Delete(info)
            unknownListView.Delete(info)
            if (selected.skipped) {
                return
            }
            selectedId := selected.selectedStudent
            ; MsgBox "Selected: " . selectedId . " " . infonb
            detectedListView.Add(, selectedId, stuList[selectedId].name)
        }
    }
}

showSelectGui() {
    global stuList
    s_Gui := Gui()
    s_Gui.Add("Text", , "Select student:")
    selectedStudent := ""
    skipped := false
    lv := s_Gui.Add("ListView", "w200 h300", ["ID", "Student Name"])
    for i, stu in stuList {
        lv.Add(, stu.id, stu.name)
    }
    lv.OnEvent("DoubleClick", selectStu_Click)
    selectStu_Click(_, info) {
        selectedStudent := info
        s_Gui.Hide()
    }
    skipButton := s_Gui.Add("Button", "y310 w100 h30", "Skip")
    skipButton.OnEvent("Click", skipButton_Click)
    skipButton_Click(*) {
        skipped := true
        s_Gui.Hide()
    }
    s_Gui.Show()
    WinWaitClose s_Gui.Hwnd
    return {
        selectedStudent: selectedStudent,
        skipped: skipped
    }
}

exportButton_Click(*) {
    global stuList, detectedStuList
    exportStuList := []
    ; IN if student exists, OUT if student does not exist
    for i, stu in stuList {
        if (attendanceStuList.Contains(stu)) {
            exportStuList.Push("IN")
        } else {
            exportStuList.Push("OUT")
        }
    }
    A_Clipboard := ca_ArrJoin(exportStuList, "`n")
    MsgBox "Exported to clipboard: " . exportStuList
}

ca_Gui.Show()