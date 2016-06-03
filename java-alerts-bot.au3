; Automatically accepting all java security / certificate alerts. Use at your own risk!
;
; Author: PK

#RequireAdmin

#include <AutoItConstants.au3>
#include <MsgBoxConstants.au3>
#include <Misc.au3>
_Singleton('java-alerts-bot')

; Ctrl + Alt + Q
HotKeySet("^!q", "terminate")

Func terminate()
   if MsgBox(BitOr($MB_YESNO, $MB_DEFBUTTON2, $MB_ICONQUESTION), "Terminating", "Terminatine " & @ScriptName & "?") = $IDYES Then
	  Exit
   EndIf
EndFunc

Local $aMousePos
Local $aWinPos

while 1
   if WinExists("[TITLE:Security Warning;CLASS:SunAwtDialog]") Then
	  WinActivate("[TITLE:Security Warning;CLASS:SunAwtDialog]")
;~    Else
;~ 	  WinWaitActive("[TITLE:Security Warning;CLASS:SunAwtDialog]", "")

	  $aMousePos = MouseGetPos()
	  $aWinPos = WinGetPos("[TITLE:Security Warning;CLASS:SunAwtDialog]")

	  if $aPos[2] == 554 and $aPos[3] == 356 then
		 BlockInput($BI_DISABLE)
		 MouseClick("primary", $aPos[0] + 45, $aPos[1] + 323, 1, 1)
		 MouseClick("primary", $aPos[0] + 415, $aPos[1] + 323, 1, 1)
		 MouseMove($aMousePos[0], $aMousePos[1], 0)
		 BlockInput($BI_ENABLE)
	  ElseIf $aPos[2] == 554 and $aPos[3] == 315 then
		 BlockInput($BI_DISABLE)
		 MouseClick("primary", $aPos[0] + 45, $aPos[1] + 275, 1, 1)
		 MouseClick("primary", $aPos[0] + 415, $aPos[1] + 275, 1, 1)
		 MouseMove($aMousePos[0], $aMousePos[1], 0)
		 BlockInput($BI_ENABLE)
	  ElseIf $aPos[2] == 556 and $aPos[3] == 245 then
		 BlockInput($BI_DISABLE)
		 MouseClick("primary", $aPos[0] + 415, $aPos[1] + 210, 1, 1)
		 MouseMove($aMousePos[0], $aMousePos[1], 0)
		 BlockInput($BI_ENABLE)
	  ElseIf $aPos[2] == 603 and $aPos[3] == 275 then
		 BlockInput($BI_DISABLE)
		 MouseClick("primary", $aPos[0] + 480, $aPos[1] + 233, 1, 1)
		 MouseMove($aMousePos[0], $aMousePos[1], 0)
		 BlockInput($BI_ENABLE)
	  EndIf
   EndIf

   Sleep(100)
WEnd