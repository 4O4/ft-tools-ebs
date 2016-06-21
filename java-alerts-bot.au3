; Automatically accepting all java security / certificate alerts. Use at your own risk!
;
; Author: PK

#RequireAdmin
#NoTrayIcon

#include <AutoItConstants.au3>
#include <MsgBoxConstants.au3>
#include <Misc.au3>
#include <Array.au3>
#include <WinAPI.au3>
#include <ScreenCapture.au3>

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
	Local $aClientSize[2]
	Local $hActiveWindow
	Local $hFoundWindow

	If WinExists($WARNING_WINDOW_PATTERN) Then
		$hFoundWindow = WinGetHandle($WARNING_WINDOW_PATTERN)
		$aClientSize = WinGetClientSize($hFoundWindow)

		If $aClientSize[0] == 548 And $aClientSize[1] == 330 Then
			#CS
				"Do you want to run this application?

				Name: ...
				Publisher: ...
				Location: ...

				Running this application may be a security risk
				Risk: ... Unable to ensure the certificate used to identify this application has not been revoked.

				Select the box below, then click Run to start the application
				"
			#CE
			_ArrayAdd($aClicks, "primary|40|300") ; "I accept the risk and want to run this application"
			_ArrayAdd($aClicks, "primary|400|300") ; "Run"
		ElseIf $aClientSize[0] == 548 And $aClientSize[1] == 289 Then
			#CS
				"Do you want to run this application?

				Publisher: ...
				Location: ...

				Running this application may be a security risk
				Risk: ...

				Select the box below, then click Run to start the application
				"
			#CE
			_ArrayAdd($aClicks, "primary|40|255") ; "I accept the risk and want to run this application"
			_ArrayAdd($aClicks, "primary|400|255") ; "Run"
		ElseIf $aClientSize[0] == 550 And $aClientSize[1] == 219 Then
			#CS
				"Do you want to Continue?
				The connection to this website is untrusted.
				Note: The certificate is not valid and cannot be used to verify the identity of this website."
			#CE
			_ArrayAdd($aClicks, "primary|415|190") ; "Continue"
		ElseIf $aClientSize[0] == 550 And $aClientSize[1] == 213 Then
			#CS
				"Do you want to Continue?
				The connection to this website is untrusted.
				Note: The certificate is not valid and cannot be used to verify the identity of this website."
			#CE
			_ArrayAdd($aClicks, "primary|415|190") ; "Continue"
		ElseIf $aClientSize[0] == 597 And $aClientSize[1] == 249 Then
			#CS
				"Do you want to run this application?
				An application is requesting permission to load a resource from location below.

				Location: ...

				Click Cancel to block loading such resources or Run to allow it to allow them to load"
			#CE
			_ArrayAdd($aClicks, "primary|475|210")
		ElseIf $aClientSize[0] == 603 And $aClientSize[1] == 296 Then
			;########## TODO: Add description, fix expected size and clicking coordinates
			_ArrayAdd($aClicks, "primary|400|250")
		ElseIf $aClientSize[0] == 543 And $aClientSize[1] == 182 Then
			#CS
				"This application would like to use a version of Java (...) that is not installed on your system.
				We recommend running the application with the latest version of Java on your computer.

				Name: ...
				Location: ...
			#CE
			_ArrayAdd($aClicks, "primary|270|155") ; "Run with the latest version"
		ElseIf $aClientSize[0] == 130 And $aClientSize[1] == 10 Then
			; There is some invisible window of such size apparently
		ElseIf $aClientSize[0] > 0 And $aClientSize[1] > 0 Then
			handleUnknownWindow($hFoundWindow, $aClientSize)
		EndIf
	ElseIf WinExists($INFO_WINDOW_PATTERN) Then
		$hFoundWindow = WinGetHandle($INFO_WINDOW_PATTERN)
		$aClientSize = WinGetClientSize($hFoundWindow)

		If $aClientSize[0] == 517 And $aClientSize[1] == 287 Then
			#CS
				"Do you want to run this application?

				Name: ...
				Publisher: ...
				Location: ...

				This application will run with unrestricted access which may put your computer and personal information at risk.
				Run this application only if you trust the location and publisher above.
				"
			#CE
;~ 			_ArrayAdd($aClicks, "primary|25|205") ; "Do not show this again for apps from the publisher and location above"
			_ArrayAdd($aClicks, "primary|390|250") ; "Run"
		ElseIf $aClientSize[0] > 0 And $aClientSize[1] > 0 Then
			handleUnknownWindow($hFoundWindow, $aClientSize)
		EndIf
	EndIf

	If UBound($aClicks) > 0 Then
		clickSequence($aClicks, $aMousePos, $hFoundWindow, $hActiveWindow)
	EndIf

	Sleep(100)
WEnd

Func clickSequence($aClicks, $aMousePos, $hWindow, $hActiveWindow)
	BlockInput($BI_DISABLE)
	WinActivate($hWindow)

	For $i = 0 To UBound($aClicks) - 1
		Local $aScreenCoords = clientToScreenCoords($hWindow, Int($aClicks[$i][1]), Int($aClicks[$i][2]))
		MouseClick($aClicks[$i][0], $aScreenCoords[0], $aScreenCoords[1], 1, 1)
	Next

	If WinExists($hActiveWindow) Then
		WinActivate($hActiveWindow)
	EndIf

	If UBound($aMousePos) >= 2 Then
		MouseMove($aMousePos[0], $aMousePos[1], 0)
	EndIf

	BlockInput($BI_ENABLE)
EndFunc   ;==>clickSequence

Func clientToScreenCoords($hHandle, $iX, $iY)
	Local $tPoint = DllStructCreate($tagPOINT)

	DllStructSetData($tPoint, "X", $iX)
	DllStructSetData($tPoint, "Y", $iY)

	$tPoint = _WinAPI_ClientToScreen($hHandle, $tPoint)

	Local $aCoords = [DllStructGetData($tPoint, "X"), DllStructGetData($tPoint, "Y")]
	Return $aCoords
EndFunc   ;==>clientToScreenCoords

Func handleUnknownWindow($hWindow, $aClientSize)
	Local $sScreenshotFile = @TempDir & "\java-alerts-bot-unknown-window-" & $aClientSize[0] & "-" & $aClientSize[1] & "-" & @MDAY & @MON & @YEAR & @HOUR & @MIN & @SEC & ".jpg"
	Local $aScreenCoordsStart = clientToScreenCoords($hWindow, 0, 0)
	Local $aScreenCoordsEnd = clientToScreenCoords($hWindow, $aClientSize[0], $aClientSize[1])

	_ScreenCapture_Capture($sScreenshotFile, $aScreenCoordsStart[0], $aScreenCoordsStart[1], $aScreenCoordsEnd[0], $aScreenCoordsEnd[1])
	#Region --- CodeWizard generated code Start ---
	;MsgBox features: Title=Yes, Text=Yes, Buttons=Yes and No, Icon=Warning, Miscellaneous=Top-most attribute
	If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
	$iMsgBoxAnswer = MsgBox(262196, @ScriptName & " - Window was not recognized", "Size: " & $aClientSize[0] & ", " & $aClientSize[1] & @CRLF & "Screenshot captured to: " & $sScreenshotFile & @CRLF & @CRLF & "Do you want to keep the application running?")
	Select
;~ 			Case $iMsgBoxAnswer = 6 ;Yes

		Case $iMsgBoxAnswer = 7 ;No
			Exit
	EndSelect
	#EndRegion --- CodeWizard generated code Start ---
EndFunc   ;==>handleUnknownWindow

Func terminate()
	If MsgBox(BitOR($MB_YESNO, $MB_DEFBUTTON2, $MB_ICONQUESTION, $MB_TOPMOST), "Terminating", "Terminate " & @ScriptName & "?") = $IDYES Then
		Exit
	EndIf
EndFunc   ;==>terminate
