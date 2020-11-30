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
	if (wParam = 1 || wParam = 2 || wParam = 6)
		SendMessage(5400,,,, "i)\Q" A_ScriptDir "\Taskbar.ahk - AutoHotkey v" A_AhkVersion "\E")
}

DeregisterWindowMessage(*)
{
	DllCall("DeregisterShellHookWindow", "Ptr", WinExist())
}
