#Global Strings
([string]$GamePath = 'E:\Steam\steamapps\common\APB Reloaded')

# Main menu, allowing user selection
function Show-Main-Menu
{
     param (
           [string]$Title = 'APB Config Tool'
     )
     Clear-Host
     Write-Host "================ $Title ================"

     Write-Host "Please Read the quick start guide if first time user."
    
     Write-Host "1: Press '1' to run Quick Config creator."
     Write-Host "2: Press '2' to apply config."
     Write-Host "3: Press '3' to backup current game directory."
     Write-Host "4: Press '4' to restore current backup game directory."
     Write-Host "5: Press '5' to read quick start guide."
     Write-Host "Q: Press 'Q' to quit."
}

#Functions go here

Function AutoSprint-Menu {
     param (
           [string]$AutoSprintMenuTitle = 'Auto Sprint Configuration Menu'
     )
#     Clear-Host
     Write-Host "================ $AutoSprintMenuTitle ================"

     Write-Host "Select what Auto Sprint Mode you want to include in your config."
    
     Write-Host "1: Press '1' to select Auto Sprint & Hold Crouch. $AutoSprintAndAutoCrouch"
     Write-Host "2: Press '2' to select Auto Sprint Only. $AutoSprintOnly"
     Write-Host "3: Press '3' to select Hold Crouch Only. $HoldCrouchOnly"

     Write-Host "Exit: Type 'Ok' to return to previous Menu."

do
{
     $AutoSprintMenuInput = Read-Host "Please make a selection"
     switch ($AutoSprintMenuInput)
     {
           '1' {
                ([string]$AutoSprintAndAutoCrouch = 'Selected')
                ([string]$AutoSprintMode = 'Sprint And Crouch')
                Copy-Item -Path '.\Configs\Auto Sprint & Hold Crouch\Auto Sprint & Hold Crouch\APBGame' -Destination '.\Application Directory\' -Recurse -Force
                Clear-Host
                AutoSprint-Menu
           } '2' {
                ([string]$AutoSprintOnly = 'Selected')
                ([string]$AutoSprintMode = 'Sprint Only')
                Copy-Item -Path '.\Configs\Auto Sprint & Hold Crouch\Auto Sprint Only\APBGame' -Destination '.\Application Directory\' -Recurse -Force
                Clear-Host
                AutoSprint-Menu
           } '3' {
                ([string]$HoldCrouchOnly = 'Selected')
                ([string]$AutoSprintMode = 'Crouch Only')
                Copy-Item -Path '.\Configs\Auto Sprint & Hold Crouch\Hold Crouch Only\APBGame' -Destination '.\Application Directory\' -Recurse -Force
                Clear-Host
                AutoSprint-Menu
           } 'Ok' {
                ([string]$AutoSprintMenuInput = 'Ok')
           } 
     }
}
until ($AutoSprintMenuInput -eq 'Ok')}

Function Localization-Menu {
     param (
           [string]$LocalizationMenuTile = 'Localization Configuration Menu'
     )
#     cls
     Write-Host "================ $LocalizationMenuTile ================"

     Write-Host "Select what Localization you want to include in your config."
    
     Write-Host "1: Press '1' to select Greyscale (Dark Grey & White). $Localization_GrayScale"
     Write-Host "2: Press '2' to select Original (Blue & Orange). $Localization_Original"
     Write-Host "3: Press '3' to select Vanilla (Green & Red). $Localization_Vanilla"
     Write-Host "4: Press '4' to select Alternative (Turquoise & Magenta). $Localization_Alternative1"
     Write-Host "5: Press '5' to select Alternative 2 (Dark Blue & Dark Red). $Localization_Alternative2"

     Write-Host "Exit: Type 'Ok' to return to previous Menu."

do
{
     $LocalizationMenuInput = Read-Host "Please make a selection"
     switch ($LocalizationMenuInput)
     {
           '1' {
                ([string]$Localization_GrayScale = 'Selected')
                ([string]$LocalizationMode = 'Greyscale (Dark Grey & White)')
                Copy-Item -Path '.\Configs\Localization\Greyscale (Dark Grey & White)\APBGame' -Destination '.\Application Directory\' -Recurse -Force
                cls
                Localization-Menu
           } '2' {
                ([string]$Localization_Original = 'Selected')
                ([string]$LocalizationMode = 'Original (Blue & Orange)')
                Copy-Item -Path '.\Configs\Localization\Original (Blue & Orange)\APBGame' -Destination '.\Application Directory\' -Recurse -Force
                cls
                Localization-Menu
           } '3' {
                ([string]$Localization_Vanilla = 'Selected')
                ([string]$LocalizationMode = 'Vanilla (Green & Red)')
                Copy-Item -Path '.\Configs\Localization\Vanilla (Green & Red)\APBGame' -Destination '.\Application Directory\' -Recurse -Force
                cls
                Localization-Menu
           } '4' {
                ([string]$Localization_Alternative1 = 'Selected')
                ([string]$LocalizationMode = 'Alternative (Turquoise & Magenta)')
                Copy-Item -Path '.\Configs\Localization\Alternative (Turquoise & Magenta)\APBGame' -Destination '.\Application Directory\' -Recurse -Force
                cls
                Localization-Menu
           } '5' {
                ([string]$Localization_Alternative2 = 'Selected')
                ([string]$LocalizationMode = 'Alternative 2 (Dark Blue & Dark Red)')
                Copy-Item -Path '.\Configs\Localization\Alternative 2 (Dark Blue & Dark Red)\APBGame' -Destination '.\Application Directory\' -Recurse -Force
                cls
                Localization-Menu
           } 'Ok' {
                ([string]$LocalizationMenuInput = 'Ok')
           } 
     }
}
until ($LocalizationMenuInput -eq 'Ok')}

Function Ragdoll-Menu {
     param (
           [string]$RagdollMenuTitle = 'Ragdoll Configuration Menu'
     )
#     cls
     Write-Host "================ $RagdollMenuTitle ================"

     Write-Host "Select what Ragdoll Mode you want to include in your config."
    
     Write-Host "1: Press '1' to select Remove All Ragdolls. $Ragdolls_All"
     Write-Host "2: Press '2' to select Remove NPC Ragdolls Only. $Ragdolls_NPC"
     Write-Host "3: Press '3' to select Remove Player Ragdolls Only. $Ragdolls_Players"

     Write-Host "Exit: Type 'Ok' to return to previous Menu."

do
{
     $RagdollMenuInput = Read-Host "Please make a selection"
     switch ($RagdollMenuInput)
     {
           '1' {
                ([string]$Ragdolls_All = 'Selected')
                ([string]$RagdollMode = 'Remove All Ragdolls')
                Copy-Item -Path '.\Configs\Remove Ragdolls\Remove All Ragdolls\APBGame' -Destination '.\Application Directory\' -Recurse -Force
                Clear-Host
                Ragdoll-Menu
           } '2' {
                ([string]$Ragdolls_NPC = 'Selected')
                ([string]$RagdollMode = 'Remove NPC Ragdolls Only')
                Copy-Item -Path '.\Configs\Remove Ragdolls\Remove NPC Ragdolls Only\APBGame' -Destination '.\Application Directory\' -Recurse -Force
                Clear-Host
                Ragdoll-Menu
           } '3' {
                ([string]$Ragdolls_Players = 'Selected')
                ([string]$RagdollMode = 'Remove Player Ragdolls Only')
                Copy-Item -Path '.\Configs\Remove Ragdolls\Remove Player Ragdolls Only\APBGame' -Destination '.\Application Directory\' -Recurse -Force
                Clear-Host
                Ragdoll-Menu
           } 'Ok' {
                ([string]$RagdollMenuInput = 'Ok')
           } 
     }
}
until ($RagdollMenuInput -eq 'Ok')}

Function QuickCFG {
     param (
           [string]$ConfigMenuTitle = 'Quick Configuration Menu'
     )
#     cls
     Write-Host "================ $ConfigMenuTitle ================"

     Write-Host "Select what options you want to include in your config."
     Write-Host "If you need to reset the configuration process select the Reset option."
    
     Write-Host "1: Press '1' to select 144hz+ Slide Fix. $144hzslidefix"
     Write-Host "2: Press '2' to select Auto Sprint & Hold Crouch. $AutoSprintMode"
     Write-Host "3: Press '3' to select Graphics. $Graphics"
     Write-Host "4: Press '4' to select Loading & Login Screen. $LoadLogin"
     Write-Host "5: Press '5' to select Localization Selection. $LocalizationMode"
     Write-Host "6: Press '6' to select Rainbow Concs & Glowing OPGL Nades. $RainbowNades"
     Write-Host "7: Press '7' to select Remove Ambient Sounds $RemoveAmbientSounds"
     Write-Host "8: Press '8' to select Remove Blood Particles. $RemoveBloodParticle"
     Write-Host "9: Press '9' to select Remove Notifications. $RemoveNotifications"
     Write-Host "10: Type '10' to select Ragdoll Selection $RagdollMode"
     Write-Host "11: Type '11' to select Remove Spray Objective Particles. $RemoveGrafitiParticles"
     Write-Host "12: Type '12' to select Remove VivoxVoiceService $RemoveVivoxVoiceService"
     Write-Host "R: Press 'R' to reset ."
     Write-Host "E: Press 'E' to exit."
do
{
     $ConfigMenuInput = Read-Host "Please make a selection"
     switch ($ConfigMenuInput)
     {
           '1' {
                ([string]$144hzslidefix = 'Selected')
                Copy-Item -Path '.\Configs\144hz+ Slide Fix\Engine' -Destination '.\Application Directory\' -Recurse -Force
                Clear-Host
                QuickCFG
           } '2' {
                AutoSprint-Menu
                Clear-Host
                QuickCFG
           } '3' {
                ([string]$Graphics = 'Selected')
                Copy-Item -Path '.\Configs\Graphics\APBGame' -Destination '.\Application Directory\' -Recurse -Force
                Clear-Host
                QuickCFG
           } '4' {
                ([string]$LoadLogin = 'Selected')
                Clear-Host
                Copy-Item -Path '.\Configs\Loading & Login Screen\APBGame' -Destination '.\Application Directory\' -Recurse -Force
                QuickCFG
           } '5' {
                Localization-Menu
                Clear-Host
                QuickCFG
           } '6' {
                ([string]$RainbowNades = 'Selected')
                Copy-Item -Path '.\Configs\Rainbow Concs & Glowing OPGL Nades\APBGame' -Destination '.\Application Directory\' -Recurse -Force
                Clear-Host
                QuickCFG
           } '7' {
                ([string]$RemoveAmbientSounds = 'Selected')
                Clear-Host
                Copy-Item -Path '.\Configs\Remove Ambient Sounds\APBGame' -Destination '.\Application Directory\' -Recurse -Force
                QuickCFG
           } '8' {
                ([string]$RemoveBloodParticles = 'Selected')
                Clear-Host
                Copy-Item -Path '.\Configs\Remove Blood Particles\APBGame' -Destination '.\Application Directory\' -Recurse -Force
                QuickCFG
           } '9' {
                ([string]$RemoveNotifications = 'Selected')
                Copy-Item -Path '.\Configs\Remove Notifications\APBGame' -Destination '.\Application Directory\' -Recurse -Force
                Clear-Host
                QuickCFG
           } '10' {
                Ragdoll-Menu
                Clear-Host
                QuickCFG
           } '11' {
                ([string]$RemoveGrafitiParticles = 'Selected')
                Copy-Item -Path '.\Configs\Remove Spray Objective Particles\APBGame' -Destination '.\Application Directory\' -Recurse -Force
                cls
                QuickCFG
           } '12' {
                ([string]$RemoveVivoxVoiceService = 'Selected')
                Copy-Item -Path '.\Configs\Remove VivoxVoiceService\Binaries' -Destination '.\Application Directory\' -Recurse -Force
                cls
                QuickCFG
           } 'r' {
                Remove-Item -Recurse -Path '.\Application Directory\*' 
                ([string]$144hzslidefix = '')
                ([string]$AutoSprintMode = '')
                ([string]$Graphics = '')
                ([string]$LoadLogin = '')
                ([string]$LocalizationMode = '')
                ([string]$RainbowNades = '')
                ([string]$RemoveAmbientSounds = '')
                ([string]$AmbientSounds = '')
                ([string]$RemoveBloodParticle = '')
                ([string]$RemoveNotifications = '')
                ([string]$RagdollMode = '')
                ([string]$RemoveGrafitiParticles = '')
                ([string]$RemoveVivoxVoiceService = '')
                ([string]$Ragdolls_All = '')
                ([string]$Ragdolls_NPC = '')
                ([string]$Ragdolls_Players = '')
                ([string]$Localization_GrayScale = '')
                ([string]$Localization_Original = '')
                ([string]$Localization_Vanilla = '')
                ([string]$Localization_Alternative1 = '')
                ([string]$Localization_Alternative2 = '')
                Clear-Host
                QuickCFG
           } 'e' {
                ([string]$ConfigMenuInput = 'e')
           } 
     }
}
until ($ConfigMenuInput -eq 'e')}
Function ApplyCFG {Copy-Item -Recurse -Force -Path '.\Application Directory\*' -Destination $GamePath}
Function BackupCurrentGame {Copy-Item -Recurse -Force -Path $GamePath -Destination '.\Backup Dir'}
Function RestoreCurrentGameBackup {
Write-Host "Are you sure you want to restore the current backup? This will delete your current game directory and replace it with the backup. If the backup does not exist you will be left without a game directory."
pause
pause
pause
pause
Remove-Item -Path $GamePath -Recurse
Copy-Item -Path '.\Backup Dir\APB Reloaded\' -Recurse -Destination $GamePath}
Function QuickStartGuide {Write-Host "QuickStartGuide"

Write-Host "Hello and Welcome to the Quickstart Guide."
Write-Host " "
Write-Host " "
Write-Host "Required Configuration"
Write-Host "Please change the GamePath under #Global Strings to your GamePath. "
Write-Host "Heres your 5 second explanation on how to use the Quick Config Creator."
Write-Host "Step 1 Know what config options you want to apply. You can find information on what specific config options do inside of the Configs directory."
Write-Host "Step 2 Select the Config options by pressing the number assosiated with the option and hitting enter. If you did it correctly it will show up with Selected after."
Write-Host "Step 3 In case you messed up selecting just select the Reset option it will reset your current settings waiting to be applied."
Write-Host "Step 4 If you feel like your done with creating your config just select the Exit option and press enter. All settings made are saved upon pressing enter to select them."
Write-Host "Step 5 Your done."
Write-Host " "
Write-Host " "
Write-Host "In case exiting the Quick Config Creator is buggy its fine to force exit the script. As long as you get up the Quick Config menu again before you exit the script theres no possibility of issues. Known to the Developer"
Write-Host " "
Write-Host " "
pause
Write-Host " "
Write-Host " "
Write-Host "How to apply the config stored in Application Directory."
Write-Host "Step 1 Select the Apply config option"
Write-Host "Step 2 Your done"
pause
Write-Host " "
Write-Host " "
Write-Host "How to Backup and Restore Game Directory"
Write-Host "Why do you want to do this? Well its simple on a fast system like the system of the developer of this script its faster to replace the game files with a backup than it is to repair them."
Write-Host "Its also way simpler to press two diffrent buttons and waiting a bit."
Write-Host "So how do i do this backup restore procedure."
Write-Host "Step 1 Run option 3 and wait until completion."
Write-Host "Step 2 your done with Backup"
Write-Host "Step 3 When your want to restore the backup just run option 4 and the backup will replace the current game directory and the old one will be deleted in the process."
pause
}
#Main menu loop
do
{
     Show-Main-Menu
     $input = Read-Host "Please make a selection"
     switch ($input)
     {
           '1' {
                Clear-Host
                QuickCFG
           } '2' {
                ApplyCFG
           } '3' {
                Clear-Host
                BackupCurrentGame
           } '4' {
                Clear-Host
                RestoreCurrentGameBackup
           } '5' {
                Clear-Host
                QuickStartGuide
           } 'q' {
                return
           }
     }
     pause
}
until ($input -eq 'q')
