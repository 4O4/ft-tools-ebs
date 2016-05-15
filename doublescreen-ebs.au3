; Automatically adjusting Oracle EBS window size to fit workarea of available screens
; Tested with two screens, should also work fine with more
;
; Author: PK

#include <Math.au3>
#include <Array.au3>
#include <WinAPI.au3>

; Get the working visible area of the desktop, this doesn't include the area covered by the taskbar.
Func _GetDesktopArea()
   Local Const $SPI_GETWORKAREA = 48
   Local $tWorkArea = DllStructCreate($tagRECT)
   _WinAPI_SystemParametersInfo($SPI_GETWORKAREA, 0, DllStructGetPtr($tWorkArea))
   Local $aReturn[4] = [DllStructGetData($tWorkArea, "Left"), DllStructGetData($tWorkArea, "Top"), _
		 DllStructGetData($tWorkArea, "Right") - DllStructGetData($tWorkArea, "Left"), DllStructGetData($tWorkArea, "Bottom") - DllStructGetData($tWorkArea, "Top")]
   Return $aReturn
EndFunc   ;==>_GetDesktopArea

Global Const $SM_VIRTUALWIDTH = 78
Global Const $SM_VIRTUALHEIGHT = 79

$VIRTUALDESKTOPWIDTH = DLLCall("user32.dll","int","GetSystemMetrics","int", $SM_VIRTUALWIDTH)[0]
$VIRTUALDESKTOPHEIGHT = DLLCall("user32.dll","int","GetSystemMetrics","int", $SM_VIRTUALHEIGHT)[0]

If WinExists("[CLASS:SunAwtFrame; REGEXPTITLE:Oracle Applications - (.*?)]") Then
   Local $hwnd = WinGetHandle("[CLASS:SunAwtFrame; REGEXPTITLE:Oracle Applications - (.*?)]")
   Local $aArray = _GetDesktopArea()

   WinMove($hwnd, "", 0, 0, _Max($VIRTUALDESKTOPWIDTH, @DesktopWidth), _Min(_Min($VIRTUALDESKTOPHEIGHT, @DesktopHeight), $aArray[3]))
EndIf