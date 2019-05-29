Local $title = "Phone screen"
local $loopcount = 0
Opt( "MouseCoordMode", 0 )
Opt( "PixelCoordMode", 0 )

Func SleepWinActive( $activeTitle, $milliseconds )
	ConsoleWrite( "sleeping " & $milliseconds & @CRLF)
	sleep($milliseconds)
	if not WinActive($activeTitle) Then
		Return false
	EndIf
	Return True
EndFunc

func hasColorInArea( $startX, $startY, $width, $height, $color1, $color2 = 0, $color3 = 0, $shadeRange = 10 )
	; return true if one of colors found in $colors
	; is in the search box
	local $array[4]

	$array[0] = 3

	$array[1] = $color1
	$array[2] = $color2
	$array[3] = $color3

	for $index = 0 to $array[0]
		if $array[$index] > 0 then
			PixelSearch( $startX, $startY, $startX+$width, $startY+$height, $array[$index], $shadeRange )
			If Not @error Then
				return true
			endif
		endif
	next
	return false
endfunc

func hasMovementInArea( $startX, $startY, $width, $height, $loops=10, $delay=250 )
	Local $checksum = PixelChecksum( $startX, $startY, $startX+$width, $startY+$height)
	ConsoleWrite("hasMovementInArea: local:" & $checksum & @crlf)

	for $x = 1 to $loops
		sleep($delay)
		Local $newChecksum = PixelChecksum( $startX, $startY, $startX+$width, $startY+$height)
		ConsoleWrite("hasMovementInArea:" & $x & " new:" & $newChecksum & @crlf)
		if $checksum <> $newChecksum Then
			return True
		Endif
	Next
	return False
EndFunc

func CaptureEsc()
	Exit
EndFunc

dim $windowX = 651
dim $windowY = 437

ConsoleWrite("Set focus to " & $title & @CRLF)
Local $hWnd = WinWaitActive( $title )
Local $aPos = WinGetPos($hWnd)

WinMove($hWnd, "", $aPos[0], $aPos[1], $windowX, $windowY)
HotKeySet ( "{ESC}", "CaptureEsc" )
Sleep(2000)
WatchVideosforGems()

Func WatchVideosforGems()
	While WinActive($title)
		MouseClick( "left", 174, 295, 1 ); watch video

		Sleep( 5000 )

		If not hasMovementInArea( 50, 60, 300, 200 ) Then
			ConsoleWrite("no more videos"&@crlf)
			ExitLoop
		endif

		if not SleepWinActive($title, 30000) Then
			ExitLoop
		EndIf

		MouseClick( "left", 438, 417, 1 ); back
		if not SleepWinActive($title, 4000) Then
			ExitLoop
		EndIf

		MouseClick( "left", 309, 257, 1 ); earn gems OK
		sleep(500)
		$loopCount +=1
		ConsoleWrite( $loopCount & " videos watched" & @CRLF )
	WEnd
	ConsoleWrite( $title & " no longer active" & @CRLF )
EndFunc
