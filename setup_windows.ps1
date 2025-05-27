# Run this command if no execution policy error: Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
# Run powershell with admin

# Util function
function Write-Start {
	param ($msg)
	Write-Host (">> "+$msg) -ForegroundColor Green
}

function Write-Done {
	Write-Host "DONE" -ForegroundColor Blue
	Write-Host
}

# Start

$UACValue
Start-Process -Wait powershell -Verb runas -ArgumentList "Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0"

Write-Start -msg "Installing Scoop..."
if (Get-Command scoop -errorAction SilentlyContinue) {
	Write-Warning "Scoop already installed"
} else {
	Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
	Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
}
Write-Done

Write-Start -msg "Initializing Scoop..."
	scoop install git
	scoop bucket add extras
	scoop bucket main
        scoop bucket add java
	scoop update
Write-Done

# Optional

$answer = Read-Host "Do you want to install LD Player? (y/n)"

if ($answer -eq "y" -or $answer -eq "yes") {
    	scoop install extras/ldplayer
} elseif ($answer -eq "n" -or $answer -eq "no") {
    	write-Host "Installation cancelled."
} else {
    	write-Host "Invalid input. Please enter y or n."
}

$answer = Read-Host "Do you want to install Coc Coc? (y/n)"

if ($answer -eq "y" -or $answer -eq "yes") {
     	scoop bucket add coccoc https://github.com/nguyenminhtan254/scoop-bucket.git
	scoop install coccoc
} elseif ($answer -eq "n" -or $answer -eq "no") {
    	write-Host "Installation cancelled."
} else {
    	write-Host "Invalid input. Please enter y or n."
}

$answer = Read-Host "Do you want to install OBS Studio? (y/n)"

if ($answer -eq "y" -or $answer -eq "yes") {
	scoop install obs-studio
} elseif ($answer -eq "n" -or $answer -eq "no") {
    	write-Host "Installation cancelled."
} else {
    	write-Host "Invalid input. Please enter y or n."
}

# Basic

Write-Start -msg "Installing Scoop's packages"
	scoop install <# Tool #> obs-studio bulk-crap-uninstaller anki winrar
	scoop install <# Coding #> vscode python oraclejdk vcredist2022

Start-Process -Wait powershell -Verb runas -ArgumentList "Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 2"

$UACValue = Get-ItemProperty -Path "REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -ErrorAction SilentlyContinue

if ($UACValue -ne $null) {
    Write-Host "Current UAC: $($UACValue.ConsentPromptBehaviorAdmin)" -ForegroundColor Blue
} else {
    Write-Host "NO UAC" -ForegroundColor Red
}