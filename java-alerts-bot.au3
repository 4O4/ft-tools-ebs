; Automatically accepting all java security / certificate alerts. Use at your own risk!
;
; Author: PK

#RequireAdmin
#NoTrayIcon

#include <AutoItConstants.au3>
#include <MsgBoxConstants.au3>
#include <Misc.au3>

_Singleton('java-alerts-bot')

; Ctrl + Alt + Q
HotKeySet("^!q", "terminate")

Const $WINDOW_PATTERN = "[TITLE:Security Warning;CLASS:SunAwtDialog]"
Func terminate()
   if MsgBox(BitOr($MB_YESNO, $MB_DEFBUTTON2, $MB_ICONQUESTION), "Terminating", "Terminatine " & @ScriptName & "?") = $IDYES Then
	  Exit
   EndIf
EndFunc

Local $aMousePos
Local $aWinPos
Local $aActiveWindow

while 1
   if WinExists($WINDOW_PATTERN) Then
	  $aMousePos = MouseGetPos()
	  $aWinPos = WinGetPos($WINDOW_PATTERN)
	  $hActiveWindow = WinGetTitle("[Active]")

	  if $aWinPos[2] == 554 and $aWinPos[3] == 356 then
		 WinActivate($WINDOW_PATTERN)
		 BlockInput($BI_DISABLE)
		 MouseClick("primary", $aWinPos[0] + 45, $aWinPos[1] + 323, 1, 1)
		 MouseClick("primary", $aWinPos[0] + 415, $aWinPos[1] + 323, 1, 1)
		 MouseMove($aMousePos[0], $aMousePos[1], 0)
		 If WinExists($aActiveWindow) Then
			WinActivate($aActiveWindow)
		 EndIf
		 MouseMove($aMousePos[0], $aMousePos[1], 0)
		 BlockInput($BI_ENABLE)
	  ElseIf $aWinPos[2] == 554 and $aWinPos[3] == 315 then
		 WinActivate($WINDOW_PATTERN)
		 BlockInput($BI_DISABLE)
		 MouseClick("primary", $aWinPos[0] + 45, $aWinPos[1] + 275, 1, 1)
		 MouseClick("primary", $aWinPos[0] + 415, $aWinPos[1] + 275, 1, 1)
		 MouseMove($aMousePos[0], $aMousePos[1], 0)
		 If WinExists($aActiveWindow) Then
			WinActivate($aActiveWindow)
		 EndIf
		 MouseMove($aMousePos[0], $aMousePos[1], 0)
		 BlockInput($BI_ENABLE)
	  ElseIf $aWinPos[2] == 556 and $aWinPos[3] == 245 then
		 WinActivate($WINDOW_PATTERN)
		 BlockInput($BI_DISABLE)
		 MouseClick("primary", $aWinPos[0] + 415, $aWinPos[1] + 210, 1, 1)
		 MouseMove($aMousePos[0], $aMousePos[1], 0)
		 If WinExists($aActiveWindow) Then
			WinActivate($aActiveWindow)
		 EndIf
		 MouseMove($aMousePos[0], $aMousePos[1], 0)
		 BlockInput($BI_ENABLE)
	  ElseIf $aWinPos[2] == 603 and $aWinPos[3] == 275 then
		 WinActivate($WINDOW_PATTERN)
		 BlockInput($BI_DISABLE)
		 MouseClick("primary", $aWinPos[0] + 480, $aWinPos[1] + 233, 1, 1)
		 MouseMove($aMousePos[0], $aMousePos[1], 0)
		 If WinExists($aActiveWindow) Then
			WinActivate($aActiveWindow)
		 EndIf
		 MouseMove($aMousePos[0], $aMousePos[1], 0)
		 BlockInput($BI_ENABLE)
	  ElseIf $aWinPos[2] == 603 and $aWinPos[3] == 296 then
		 WinActivate($WINDOW_PATTERN)
		 BlockInput($BI_DISABLE)
		 MouseClick("primary", $aWinPos[0] + 400, $aWinPos[1] + 250, 1, 1)
		 MouseMove($aMousePos[0], $aMousePos[1], 0)
		 If WinExists($aActiveWindow) Then
			WinActivate($aActiveWindow)
		 EndIf
		 MouseMove($aMousePos[0], $aMousePos[1], 0)
		 BlockInput($BI_ENABLE)
	  EndIf
   EndIf

   Sleep(100)
WEnd