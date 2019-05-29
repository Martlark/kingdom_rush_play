#Include <Clipboard.au3>
#Include <Array.au3>
#include <date.au3>
#include <ScreenCapture.au3>
#include <Constants.au3>

AutoItSetOption("MustDeclareVars", 1)

dim $properties[1][3], $propertiesCount = 0

dim $locations[1][6], $locationsCount = 0


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


func logMessage( $message )
	; log message to file log.txt
	;
	local $fileName = "log.txt"
	local $file, $retryCount, $retryValue = 100

	for $retryCount = 0 to $retryValue
		$file = FileOpen( $fileName, 1)
		; Check if file opened for writing OK
		If $file = -1 Then
			sleep( 10 )
		else
			exitloop
		endif
	next
	If $file = -1 Then
		MsgBox(0, "Error", "Unable to open log file." & $fileName)
		Exit
	EndIf

	FileWrite($file, @HOUR & ":" & @MIN & " " ) ; time stamp
	FileWrite($file, $message & @CRLF)

	FileClose($file)
endFunc


func propPut( $name, $value )
	; put or replace a propery in the list
	; no more long lists of global variables
	; works like a map or dictionary
	local $propIndex = _ArraySearch( $properties, $name )

	if $propIndex = -1 then
		redim $properties[$propertiesCount+1][2]

		$properties[$propertiesCount][0] = $name
		$properties[$propertiesCount][1] = $value
		$propertiesCount += 1
	else
		$properties[$propIndex][1] = $value
	endif
endFunc

func propGet( $name, $defaultValue = "" )
	; get the property out
	local $propIndex = _ArraySearch( $properties, $name )

	if $propIndex = -1 then
		propPut( $name, $defaultValue )
		return $defaultValue
	else
		return $properties[$propIndex][1]
	endif
endfunc

Func SleepWinActive( $activeTitle, $milliseconds )
	ConsoleWrite( "sleeping " & $milliseconds & @CRLF)
	sleep($milliseconds)
	if not WinActive($activeTitle) Then
		Return false
	EndIf
	Return True
EndFunc

Local $title = "Phone screen"
Local $loopCount = 0
Opt( "MouseCoordMode", 0 )

ConsoleWrite("Set focus to Phone screen" & @CRLF)
WinWaitActive( $title )


	if hasColorInArea( 512, 290, 5, 5, 0xa5ebf9 ) Then
		ConsoleWrite( "Restart" & @CRLF )
EndIf
	exit

Func WatchVideosforGems()
	While WinActive($title)
		MouseClick( "left", 174, 295, 1 ); watch video
		if not SleepWinActive($title, 35000) Then
			ExitLoop
		EndIf
		MouseClick( "left", 438, 397, 1 ); back
		if not SleepWinActive($title, 4000) Then
			ExitLoop
		EndIf
		MouseClick( "left", 309, 257, 1 ); earn gems OK
		sleep(500)
		$loopCount +=1
		ConsoleWrite( $loopCount & " videos watched" & @CRLF )
	WEnd
	ConsoleWrite( $title & " no longer active" )
EndFunc

dim $buildingLength = 9
dim $reinforementsDelay = 10
dim $reinforementsCount = 10
dim $buildingCount = 0
dim $fireDelay = 30
dim $fireCount = 30
dim $buildingDelay = 60
dim $sleepCount = 0
dim $lane = 1

dim $buildings[$buildingLength+1][3]

func AddLocation( $name, $x, $y, $color1 = 0, $color2 = 0, $color3 = 0 )
	redim $locations[$locationsCount+1][6]
	$locations[$locationsCount][0] = $name
	$locations[$locationsCount][1] = $x
	$locations[$locationsCount][2] = $y
	$locations[$locationsCount][3] = $color1
	$locations[$locationsCount][4] = $color2
	$locations[$locationsCount][5] = $color3
	$locationsCount += 1
EndFunc

Func LocationClick( $name )
	local $index = _ArraySearch( $locations, $name )

	if $index > -1 then
		sleep( 200 )
		MouseClick( "left", $locations[$index][1], $locations[$index][2] )
		sleep( 500 )
	Else
		ConsoleWriteError( "location " & $name & " not found" & @CRLF )
	endif
	return $index
EndFunc

func FortBuild( $locationNumber, $type )
	Local $name = "build " & $locationNumber
	local $index = LocationClick( $name )
	$buildingCount = 0

	if $index > -1 Then
		if $type = "bomb" then
			MouseClick( "left", $locations[$index][1] + 40, $locations[$index][2] + 40, 2 )
		ElseIf $type = "mage" Then
			MouseClick( "left", $locations[$index][1] - 40, $locations[$index][2] + 40, 2 )
		Else
			ConsoleWriteError( "unknown fort type " & $type )
		EndIf
		$buildings[$locationNumber][0] = $type
		$buildings[$locationNumber][1] = 0
		$buildings[$locationNumber][2] = 1
	endIf
	Sleep( 500 )
EndFunc

func FortUpgrade( $locationNumber )
	Local $name = "build " & $locationNumber
	$buildingCount = 0

	if LocationClick( $name ) Then
		local $index = _ArraySearch( $locations, $name )
		MouseClick( $locations[$index][1], $locations[$index][2] - 40, 2 )
		$buildings[$locationNumber][2] += 1
	endIf
	Sleep( 500 )
EndFunc

AddLocation( "endlessvalley", 289, 216 )
AddLocation( "to battle",517, 341 )
AddLocation( "try again", 321, 290, 0xf8e3b4 )

AddLocation( "start wave 1", 190, 71 )
AddLocation( "start wave 2", 450, 69 )
AddLocation( "start wave 3", 580, 203 )

AddLocation( "reinforcements", 102, 355 )
AddLocation( "fire", 55, 356 )
AddLocation( "hero", 46, 113 )

AddLocation( "lane 1", 252, 265 )
AddLocation( "lane 2", 399, 265 )

AddLocation( "build 1", 320, 262 )
AddLocation( "build 2", 342, 217 )
AddLocation( "build 3", 434, 274 )
AddLocation( "build 4", 208, 223 )
AddLocation( "build 5", 513, 274 )
AddLocation( "build 6", 251, 153 )
AddLocation( "build 7", 427, 179 )
AddLocation( "build 8", 137, 157 )
AddLocation( "build 9", 379, 154 )

func ReinforcementsPlace()
	$reinforementsCount = 0
	local $lane = Random(1, 2, 1)

	ConsoleWrite( "ReinforcementsPlace:" & $lane & @CRLF )

	LocationClick( "reinforcements" )
	LocationClick( "lane " & $lane )
EndFunc

func RainFire()
	$fireCount = 0
	local $lane = Random(1, 2, 1)

	ConsoleWrite( "RainFire:" & $lane & @CRLF )
	LocationClick( "fire" )
	LocationClick( "lane " & $lane )
EndFunc

func StartWave()
	; click each start wave location
	for $x = 1 to 3
		local $index = LocationClick( "start wave " & $x )
		if $index > -1 Then
			MouseClick( "left" )
			MouseClick( "left" )
			for $xPlus = 0 to 25 step 5
				MouseMove( $locations[$index][1]+$xPlus, $locations[$index][2] )
				MouseClick( "left" )
				MouseClick( "left" )
			next
		EndIf
	next
EndFunc

StartWave()

; scroll up

MouseClickDrag( "left", 305, 350, 326, 67, 10 )

; initial builds

FortBuild( 1, "bomb" )
FortBuild( 2, "bomb" )
FortBuild( 3, "bomb" )

while WinActive( $title )
	if not SleepWinActive( $title, 1000 ) Then
		ExitLoop
	EndIf

	$reinforementsCount += 1
	$fireCount += 1
	$buildingCount += 1

	ConsoleWrite( $reinforementsCount & " " & $fireCount & @CRLF )

	if $reinforementsCount > $reinforementsDelay Then
		ReinforcementsPlace()
	EndIf

	if $fireCount > $fireDelay Then
		RainFire()
	EndIf

	for $x = 1 to $buildingLength
		if not $buildings[$x][0] = "" Then
			$buildings[$x][1] += 1
		Else
			if $buildingCount > $buildingDelay Then
				FortBuild($x, (Mod($x, 2) == 0) ? "bomb" : "mage" )
				ExitLoop
			EndIf
		EndIf
		if $buildings[$x][1] > $buildingDelay Then
			FortUpgrade($x)
			$buildings[$x][1] = 0
			ExitLoop
		EndIf
	Next

	if hasColorInArea( 517, 292, 5, 5, 0x9de5f4 ) Then
		ConsoleWrite( "Restart" & @CRLF )
		$reinforementsCount = $reinforementsDelay
		$fireCount = $fireDelay
		$buildingCount = 0
		LocationClick( "try again" )
		ExitLoop
	EndIf
WEnd