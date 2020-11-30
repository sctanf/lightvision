#Persistent
#SingleInstance force
#NoTrayIcon
ListLines(0)
DetectHiddenWindows(1)
SetTitleMatchMode("RegEx")
ProcessSetPriority("Realtime")
MyGui := GuiCreate("+LastFound")
OnExit("DeregisterWindowMessage")

DllCall("RegisterShellHookWindow", "Ptr", WinExist())
OnMessage(DllCall("RegisterWindowMessage", "Str", "SHELLHOOK"), "RegisterWindowMessage")

SplitPath(A_ScriptDir,, SkinDir)

WinWaitClose("i)\Q" SkinDir "\taskbar.ini ahk_class RainmeterMeterWindow ahk_exe Rainmeter.exe\E")
ExitApp

RegisterWindowMessage(wParam, thisId, *)
{
	If (wParam = 1)
	{
		try thisStyle := WinGetStyle("ahk_id " thisId)
		try thisExStyle := WinGetExStyle("ahk_id " thisId)
		try if (!(thisStyle & 0x80000000) && !(thisStyle & 0x40000000) && !(thisExStyle & 0x80) && (thisStyle & 0xC00000))
		{
			WinSetStyle(-0xC00000, "ahk_id " thisId)
		}
	}
	if (wParam = 1 || wParam = 2 || wParam = 6)
		SendMessage(5400,,,, "i)\Q" A_ScriptDir "\Taskbar.ahk - AutoHotkey v" A_AhkVersion "\E")
}

DeregisterWindowMessage(*)
{
	DllCall("DeregisterShellHookWindow", "Ptr", WinExist())
}
