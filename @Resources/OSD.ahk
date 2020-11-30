#Persistent
#SingleInstance force
#NoTrayIcon
ListLines(0)
DetectHiddenWindows(1)
SetTitleMatchMode("RegEx")
ProcessSetPriority("Realtime")
OnMessage(5000, "CheckOSD")
OnMessage(10000, "exit")
SplitPath(A_ScriptDir,, SkinDir)
SplitPath(SkinDir, SkinName)

send_WM_COPYDATA(ByRef StringToSend, ByRef TargetWindow)
{
	VarSetCapacity(CopyDataStruct, 3*A_PtrSize, 0)
	SizeInBytes := (StrLen(StringToSend) + 1) * (A_IsUnicode ? 2 : 1)
	NumPut(1, CopyDataStruct)
	NumPut(SizeInBytes, CopyDataStruct, A_PtrSize)
	NumPut(&StringToSend, CopyDataStruct, 2*A_PtrSize)
	SendMessage(0x4a, 0, &CopyDataStruct,, TargetWindow)
	return ErrorLevel
}

sendBang(command)
{
	Global SkinName
	commandWrap := command " `"" SkinName "\OSD`""
	send_WM_COPYDATA(commandWrap, "i)\Q" SkinDir "\OSD\osd.ini ahk_class RainmeterMeterWindow ahk_exe Rainmeter.exe\E")
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
	sendBang("!SetOption AHK WindowName `"" A_ScriptFullPath " - AutoHotkey v" A_AhkVersion "`"")
sendBang("!UpdateMeasure `"AHK`"")

sendBang("!SetOption Volume Text `"" round(SoundGetVolume()) "`"")
sendBang("!UpdateMeter Volume")

WinWaitClose("i)\Q" SkinDir "\OSD\osd.ini ahk_class RainmeterMeterWindow ahk_exe Rainmeter.exe\E")
ExitApp

;SoundGetName()
~Volume_Mute::
~Volume_Down::
~Volume_Up::
if (SoundGetMute())
{
	sendBang("!ShowMeter Mute")
	sendBang("!HideMeter Volume")
}
else
{
	sendBang("!HideMeter Mute")
	sendBang("!ShowMeter Volume")
}
sendBang("!SetOption Volume Text `"" round(SoundGetVolume()) "`"")
sendBang("!UpdateMeter Volume")
sendBang("!CommandMeasure Processor OSDStateChange()")
return

CheckOSD(*)
{
	SendInput("{Volume_Mute}{Volume_Mute}")
}
