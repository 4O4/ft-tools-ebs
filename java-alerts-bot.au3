; Automatically accepting all java security / certificate alerts. Use at your own risk!
;
; Author: PK

#RequireAdmin
#NoTrayIcon

#include <AutoItConstants.au3>
#include <MsgBoxConstants.au3>
#include <Misc.au3>
#include <Array.au3>

_Singleton('java-alerts-bot')
AutoItSetOption("MustDeclareVars", 1)

; Ctrl + Alt + Q
HotKeySet("^!q", "terminate")

Local Const $WARNING_WINDOW_PATTERN = "[REGEXPTITLE:Security Warning|Warning - Unavailable Version of Java Requested;CLASS:SunAwtDialog]"
Local Const $INFO_WINDOW_PATTERN = "[TITLE:Security Information;CLASS:SunAwtDialog]"

While 1
   Local $aClicks[0][3]
   Local $aMousePos = MouseGetPos()
   Local $hActiveWindow = WinGetTitle("[Active]")
   Local $aWinPos[4]
   Local $hActiveWindow
   Local $hFoundWindow

   If WinExists($WARNING_WINDOW_PATTERN) Then
	  $hFoundWindow = WinGetTitle($WARNING_WINDOW_PATTERN)
	  $aWinPos = WinGetPos($hFoundWindow)

	  If $aWinPos[2] == 554 And $aWinPos[3] == 356 Then
		 _ArrayAdd($aClicks, "primary|45|323")
		 _ArrayAdd($aClicks, "primary|415|323")
	  ElseIf $aWinPos[2] == 554 And $aWinPos[3] == 315 Then
		 _ArrayAdd($aClicks, "primary|45|275")
		 _ArrayAdd($aClicks, "primary|415|275")
	  ElseIf $aWinPos[2] == 556 And $aWinPos[3] == 245 Then
		 _ArrayAdd($aClicks, "primary|415|210")
	  ElseIf $aWinPos[2] == 603 And $aWinPos[3] == 275 Then
		 _ArrayAdd($aClicks, "primary|480|233")
	  ElseIf $aWinPos[2] == 603 And $aWinPos[3] == 296 Then
		 _ArrayAdd($aClicks, "primary|400|250")
	  ElseIf $aWinPos[2] == 549 And $aWinPos[3] == 208 Then
		 _ArrayAdd($aClicks, "primary|270|180")
	  EndIf
   ElseIf WinExists($INFO_WINDOW_PATTERN) Then
	  $hFoundWindow = WinGetTitle($INFO_WINDOW_PATTERN)
	  $aWinPos = WinGetPos($hFoundWindow)

	  If $aWinPos[2] == 517 And $aWinPos[3] == 287 Then
;~ 		 _ArrayAdd($aClicks, "primary|25|205") ; "Do not prompt again" checkbox
		 _ArrayAdd($aClicks, "primary|400|255")
	  EndIf
   EndIf

   If UBound($aClicks) > 0 Then
	  clickSequence($aClicks, $aMousePos, $hFoundWindow, $aWinPos, $hActiveWindow)
   EndIf

   Sleep(100)
WEnd

Func clickSequence($aClicks, $aMousePos, $hFoundWindow, $aWinPos, $hActiveWindow)
   BlockInput($BI_DISABLE)
   WinActivate($hFoundWindow)

   For $i = 0 To UBound($aClicks) - 1
	  MouseClick($aClicks[$i][0], $aWinPos[0] + Int($aClicks[$i][1]), $aWinPos[1] + Int($aClicks[$i][2]), 1, 1)
   Next

   If WinExists($hActiveWindow) Then
	  WinActivate($hActiveWindow)
   EndIf

   If UBound($aMousePos) >= 2 Then
	  MouseMove($aMousePos[0], $aMousePos[1], 0)
   EndIf

   BlockInput($BI_ENABLE)
EndFunc

Func terminate()
   If MsgBox(BitOr($MB_YESNO, $MB_DEFBUTTON2, $MB_ICONQUESTION), "Terminating", "Terminate " & @ScriptName & "?") = $IDYES Then
	  Exit
   EndIf
EndFunc