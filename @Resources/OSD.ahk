#Persistent
#SingleInstance force
#NoTrayIcon
ListLines(0)
ProcessSetPriority("Realtime")
OnMessage(5000, "triggerShort")
OnMessage(5001, "triggerLong")
OnMessage(6000, "triggerRedraw")
OnMessage(10000, "exit")
SplitPath(A_ScriptDir,, ResourcesDir)
SplitPath(ResourcesDir,,,, SkinName)

send_WM_COPYDATA(ByRef StringToSend, ByRef TargetWindowClass)
{
	VarSetCapacity(CopyDataStruct, 3*A_PtrSize, 0)
	SizeInBytes := (StrLen(StringToSend) + 1) * (A_IsUnicode ? 2 : 1)
	NumPut(1, CopyDataStruct)
	NumPut(SizeInBytes, CopyDataStruct, A_PtrSize)
	NumPut(&StringToSend, CopyDataStruct, 2*A_PtrSize)
	SendMessage(0x4a, 0, &CopyDataStruct,, "ahk_class " TargetWindowClass)
	return ErrorLevel
}

sendBang(command)
{
	Global SkinName
	commandWrap := command " `"" SkinName "\OSD`""
	send_WM_COPYDATA(commandWrap, "ahk_class RainmeterMeterWindow")
}

active := false
waited := 0
transparencyOld := 0
transparency := 0
hoverOld := 0
hover := 0
timer := 0
timer1 := 0
timer2 := 0
velocity1 := 0
velocity2 := 0
triggerShort(*)
{
	Global velocity1 := 255
	Global velocity2 := -8.5
	Global timer1 := 0
	Global timer2 := 2500
	Global timer := 0
}
triggerLong(*)
{
	Global active
	if (!active)
	{
		Global velocity1 := 17
		Global velocity2 := -8.5
		Global timer1 := 2500
		Global timer2 := 7500
		Global timer := 0
	}
	else
		Global waited := A_TickCount
}
triggerRedraw(*)
{
	Global active
	if (active)
		sendBang("!Redraw")
}

exit(*)
{
	ExitApp
}

if (A_IsCompiled)
{
	WinSetTitle(A_ScriptFullPath, "ahk_id " A_ScriptHwnd)
	sendBang("!SetOption AHK WindowName `"" A_ScriptFullPath "`"")
}
else
	sendBang("!SetOption AHK WindowName `"" A_ScriptDir "\OSD.ahk - AutoHotkey v" A_AhkVersion "`"")
sendBang("!UpdateMeasure `"AHK`"")

volume := round(SoundGetVolume())
mute := SoundGetMute()
sendBang("!SetOption Volume Text `"" volume "`"")
sendBang("!UpdateMeter Volume")
sendBang("!Redraw")
Loop
{
	if (round(SoundGetVolume()) != volume) 
	{
		volume := round(SoundGetVolume())
		sendBang("!SetOption Volume Text `"" volume "`"")
		sendBang("!UpdateMeter Volume")
		sendBang("!Redraw")
		triggerShort()
	}
	if (SoundGetMute() != mute)
	{
		mute := SoundGetMute()
		if (mute)
		{
			sendBang("!ShowMeter Mute")
			sendBang("!HideMeter Volume")
		}
		else
		{
			sendBang("!HideMeter Mute")
			sendBang("!ShowMeter Volume")
		}
		sendBang("!Redraw")
		triggerShort()
	}
	if (timer1 > 0 || timer2 > 0)
	{
		transparencyOld := transparency
		hoverOld := hover
		timer += 16
		if (timer >= timer1)
		{
			transparency += velocity1
			if (transparency > 255)
			{
				timer1 := 0
				velocity1 := 0
				transparency := 255
			}
		}
		if (timer >= timer2)
		{
			transparency += velocity2
			if (transparency < 0)
			{
				timer2 := 0
				velocity2 := 0
				transparency := 0
			}
		}
		if (transparencyOld != transparency || hoverOld != hover)
		{
			if (transparency = 0)
			{
				sendBang("!Hide")
				active := false
			}
			else
			{
				sendBang("!Show")
				active := true
			}
			if (hover)
				sendBang("!SetTransparency `"" transparency/2 "`"")
			else
				sendBang("!SetTransparency `"" transparency "`"")
		}
		if (!timer1 & !timer2)
			timer := 0
		if (!active & waited)
		{
			if ((A_TickCount - waited) < 2500)
			{
				velocity1 := 17
				velocity2 := -8.5
				timer1 := 2500 - (A_TickCount - waited)
				timer2 := 7500 - (A_TickCount - waited)
			}
			waited := 0
		}
		DllCall("Sleep", "UInt", 11)
	}
	else
		Sleep 100
}