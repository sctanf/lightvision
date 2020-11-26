#Persistent
#SingleInstance force
#NoTrayIcon
ProcessSetPriority("Realtime")
MyGui := GuiCreate("+LastFound")
OnExit("DeregisterWindowMessage")
DllCall("RegisterShellHookWindow", "Ptr", WinExist())
OnMessage(DllCall("RegisterWindowMessage", "Str", "SHELLHOOK"), "RegisterWindowMessage")
return

RegisterWindowMessage(wParam, lParam, *)
{
	if (wParam = 32776)
	{
		msgbox("ok")
		PostMessage(0x111, wParam, lParam,, A_ScriptDir "\Taskbar.ahk - AutoHotkey v" A_AhkVersion)
	}
}

DeregisterWindowMessage(*)
{
	DllCall("DeregisterShellHookWindow", "Ptr", WinExist())
}
