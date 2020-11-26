#Persistent
#SingleInstance force
#NoTrayIcon
ProcessSetPriority("Realtime")
CoordMode "Mouse", "Screen"

~$RButton::
MouseGetPos(MouseStartX, MouseStartY, MouseWin)
WinGetPos(OriginalPosX, OriginalPosY, width, height, "ahk_id " MouseWin)
if ((WinGetMinMax("ahk_id " MouseWin)=0)&(width!=(SysGet(78)-SysGet(76)))&(height!=(SysGet(79)-SysGet(77))))
	SetTimer("WatchMouse", 10)
return

WatchMouse()
{
	global
	if (!GetKeyState("RButton"))
	{
		SetTimer("WatchMouse", 0)
		return
	}
	if (GetKeyState("Escape"))
	{
		SetTimer("WatchMouse", 0)
		WinMove("ahk_id " MouseWin,, OriginalPosX, OriginalPosY)
		return
	}
	MouseGetPos(MouseX, MouseY)
	WinGetPos(WinX, WinY,,, "ahk_id " MouseWin)
	SetWinDelay(-1)
	WinMove(WinX+MouseX-MouseStartX, WinY+MouseY-MouseStartY,,, "ahk_id " MouseWin)
	MouseStartX := MouseX
	MouseStartY := MouseY
	return
}