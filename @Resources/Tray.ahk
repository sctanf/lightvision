#SingleInstance force
#NoTrayIcon
ProcessSetPriority("Realtime")
DetectHiddenWindows 1
SetControlDelay -1
SetWinDelay 0
ControlClick "Button2", "ahk_class Shell_TrayWnd",,,, "NA"
if WinWait("ahk_class NotifyIconOverflowWindow",, 3) {
	Sleep 100
	WinActivate("ahk_class NotifyIconOverflowWindow")
	While WinActive("ahk_class NotifyIconOverflowWindow")
	{
		Sleep 100
		WinGetPos x,y, WidthOfTray, HeightOfTray, "ahk_class NotifyIconOverflowWindow"
		TrueX := A_ScreenWidth - WidthOfTray
		TrueY := A_ScreenHeight - HeightOfTray
		WinMove TrueX, TrueY,,, "ahk_class NotifyIconOverflowWindow"
	}
	;WinHide("ahk_class NotifyIconOverflowWindow")
	Return
}
else
	Return
ExitApp
