$A = "$PSScriptRoot"
$P = Get-Volume -FriendlyName PLAYDATE | Select-Object -expandproperty DriveLetter
$P = $P + ":"
$PDSerial = Get-WmiObject Win32_logicaldisk | Where-Object -Property Name -eq "$P" | Select-Object -ExpandProperty volumeserialnumber
Echo "Playdate Community Image Installer!"
Echo "Playdate found at drive $P"
Echo "Playdate volume serial is $PDSerial"
Echo "Script running from $A"

if ($PDSerial -ne 12345678) {
	echo "Incorrect Serial! Expected 12345678 for a Playdate!"
	exit
	}
$Userid = dir -Directory "$P\Games\User\user*" | Select-Object -First 1 -ExpandProperty Name
$Userid = $Userid.Substring(0, $Userid.IndexOf('.') + 1 + $Userid.Substring($Userid.IndexOf('.') + 1).IndexOf('.')) + "."

$B = "$A\image\"
$C = "$P\Games\User\"
$D = "$P\Games\Purchased\"
$E = "$P\Games\User\$Userid"

$F = Dir -Directory "$B" | Select-Object -ExpandProperty Name

function The-Process {
	$H = (Get-Content "$I\pdxinfo" | ConvertFrom-StringData).imagepath
	if (Test-Path -Path "$I\$H\") {
		Get-ChildItem -Path "$B$G" -Include *.pdi -Recurse |
		Copy-Item -Destination "$I\$H\"
	} else {
		New-Item -Path "$I" -Name "$H" -ItemType "directory"
		Copy-Item -Path "$I\$H.pdi" -Destination "$I\$H\"
		Get-ChildItem -Path "$B$G" -Include *.pdi -Recurse |
		Copy-Item -Destination "$I\$H\"
	}
}

Foreach ($G in $F) {
	if (Test-Path -Path "$C$G") {
		$I = "$C$G"
		The-Process
	}
	
	if (Test-Path -Path "$D$G") {
		$I = "$D$G"
		The-Process
	}
	
	if (Test-Path -Path "$E$G") {
		$I = "$E$G"
		The-Process
	}
}
echo Done!
pause
	

