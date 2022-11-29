#Ever Green Variables
$ScriptName = 'Feline Matrix Assistant Toolkit Version 1.0RC1'
$Access_Token = 'REPLACE_ME_ACCESS_TOKEN'
$homeserver_url = 'REPLACE_ME_HOMESERVER_URL'
$username = 'REPLACE_ME_MXID'

# Main menu, allowing user selection
function Show-Main-Menu{
    Clear-Host
    Write-Host "================ $ScriptName  ================"
    Write-Host "1: Press '1' for manual room upgrade."
    Write-Host "2: Press '2' for manual upgrade with notice."
#1.2 Scoped    Write-Host "3: Press '3' for manual upgrade with notice and space adding."
#1.2 Scoped    Write-Host "4: Press '4' for manual upgrade with notice and space update."
    Write-Host "5: Press '5' for manual tombstone."
    Write-Host "6: Press '6' for manual tombstone with notice."
    Write-Host "7: Press '7' for custom powerlevel new room."
#Potentially 1.1 Scoped aka if it happens at all its 1.1 earliest   Write-Host "8: Press '8' for sending custom state events."
#1.2 Scoped    Write-Host "9: Press '9' for Knocking on target room"
    Write-Host "q: Press 'q' to quit."
    Write-Host "================ Warnings ================"
    Write-Host "This script is intended for advanced users who understand what they are trying to do."
    Write-Host "Feline Matrix Assistant does make tasks easier yes. This does not mean that you should missuse it."
    Write-Host "Feline Matrix Assistant is a dangerous and powerful tool use it with care."
}
#Functions go here
Function Manual_Upgrade {
    #Making all the variables Null here to make sure they are ALWAYS empty upon initialisation of this function. This is probably not needed but still cant hurt to be too sure. We can always clean this up later.
    $room_name = $null
    $room_version = $null
    $powerlevel = $null
    $powerlevel_string = $null
    $oldroom_ID = $null
    $lastevent_old_room = $null
    do
    {   
        Clear-Host
        Write-Host "================ Current Variable States ================"
        Write-Host "Current Access Token is: $Access_token"
        Write-Host "Current homeserver URL is: $homeserver_url"
        Write-Host "Room name is set to: $room_name"
        Write-Host "Currently selected room version is: $room_version"
        Write-Host "PL for $username is $powerlevel."
        Write-Host "Selected Old Room ID is: $oldroom_ID"
        Write-Host "Selected Last Event in old room is: $lastevent_old_room"
        Write-Host "================ Manual Upgrade Variable Selection ================"
        Write-Host "1: Press '1' to configure Variables."
        Write-Host "2: Press '2' to Erase Variables."
        Write-Host "ok: Write 'ok' to execute manual room upgrade."
        Write-Host "q: Press 'q' to exit to main menu without executing the upgrade."
         $sub_menu_user_select = Read-Host "Please make a selection"
         switch ($sub_menu_user_select)
            {
               '1' {
                    Clear-Host
                    Write-Host "Please fill in the variables requested. You will be given a chance to review and retry before execution of upgrade."
                    $room_name = Read-Host "Please fill in the desired room name."
                    [string]$room_version = Read-Host "Please enter the desired room version." #Explicitly String declared because room versions are ALWAYS strings in matrix so why not. Yes they are strings even when they are "ints" like 10. Because v10 is also a valid room version its just the version we call v10 is actually called 10 in the JSON.
                    $powerlevel_string = Read-Host "Please enter the desired highest Powerlevel for users in the room at room creation. Spec default is 100. Recomended by FMA is 42000." #PL is refered to string here because we get a string from read host.
                    [int]$powerlevel = $powerlevel_string #This convert exists because Powerlevels are Always supposed to be intergers. This script will not support Interger PL in this mode. If you want to abuse your v9 rooms with Int PL i trust you to figure out to how make the script not cry and have fun with that.
                    $oldroom_ID = Read-Host "Please enter the room ID of the old room."
                    $lastevent_old_room = Read-Host "Please enter the event ID for the last event in the old room pre tombstone. (No need to be perfectly exact its treated more as a jump to point.)"
                    
                } '2' {
                    Clear-Host
                    Write-Host "Clearing Variables"
                    $room_name = $null
                    $room_version = $null
                    $powerlevel = $null
                    $powerlevel_string = $null
                    $oldroom_ID = $null
                    $lastevent_old_room = $null
                    $null = Read-Host "Enter any input and press enter to proceed. Or just press enter." #Writing to null here is a way to maintain cross platform due to that powershell does actually not have a easy cross platform way to pause a script outside of this. Pause is windows exclusive and actually launches a CMD program for those who didnt realise it. Since FMA is aiming to be cross platform that eliminates it from consideration.
                } 'ok' {
                    #New Rooms Create Event represented as PSCustomObject
                    $createevent_PSCustom = [PSCustomObject]@{
                        name = $room_name
                        room_version = $room_version
                        power_level_content_override = @{
                            users = @{
                                $username = [int]$powerlevel
                            }
                        }
                        creation_content = @{
                            predecessor = @{
                                room_id = $oldroom_ID
                                event_id = $lastevent_old_room
                            }
                        }
                    }
    
                    #Turns the PS Custom Object into JSON
                    $createevent_JSON = ConvertTo-Json -InputObject $createevent_PSCustom -depth 100
                    #URIs needed by this function sits here because its after the input stage and we need to be post input stage to have access to old room ID.
                    $uri_createroom = "https://$homeserver_url/_matrix/client/v3/createRoom"
                    #Creates the New Room using the JSON in Custom Object Format above.
                    $createresponse = Invoke-RestMethod -Uri $uri_createroom -Method POST -Headers @{Authorization=("Bearer $Access_Token")} -body $createevent_JSON -ContentType "application/json"
                    #Tombstone represented as PS Custom Object. Sits here because its AFTER we have the required data.
                    $oldroomtombstone_PSCustom = [PSCustomObject]@{
                    replacement_room = $createresponse.room_id
                    }
                    #Tombstone turned from PS Custom to JSON.
                    $oldroomtombstone_JSON = ConvertTo-Json -InputObject $oldroomtombstone_PSCustom -depth 100
                    #Tombstone URI
                    $uri_tombstone = "https://$homeserver_url/_matrix/client/v3/rooms/$oldroom_ID/state/m.room.tombstone"
                    #Sends the Tombstone into the old room completing the chain.
                    Invoke-RestMethod -Uri $uri_tombstone -Method PUT -Headers @{Authorization=("Bearer $Access_Token")} -body $oldroomtombstone_JSON -ContentType "application/json"
                    Write-Host "Creation and linking of rooms completed. To complete the upgrade complete any manual transfers you desire to do."
                    $null = Read-Host "Enter any input and press enter to proceed. Or just press enter."
                    $sub_menu_user_select = 'q'
                    return
                } 'q' {
                    return
                }
            }
    }
    until ($sub_menu_user_select -eq 'q')
}
Function Manual_Upgrade_With_Notice {
    #Making all the variables Null here to make sure they are ALWAYS empty upon initialisation of this function. This is probably not needed but still cant hurt to be too sure. We can always clean this up later.
    $room_name = $null
    $room_version = $null
    $powerlevel = $null
    $powerlevel_string = $null
    $oldroom_ID = $null
    $alias_full = $null
    do
    {   
        Clear-Host
        Write-Host "================ Current Variable States ================"
        Write-Host "Current Access Token is: $Access_token"
        Write-Host "Current homeserver URL is: $homeserver_url"
        Write-Host "Room name is set to: $room_name"
        Write-Host "Currently selected room version is: $room_version"
        Write-Host "PL for $username is $powerlevel."
        Write-Host "Selected Old Room ID is: $oldroom_ID"
        Write-Host "Selected Alias for the room is: $alias_full"
        Write-Host "================ Manual Upgrade with Notice Variable Selection ================"
        Write-Host "1: Press '1' to configure Variables."
        Write-Host "2: Press '2' to Erase Variables."
        Write-Host "ok: Write 'ok' to execute manual room upgrade."
        Write-Host "q: Press 'q' to exit to main menu without executing the upgrade."
         $sub_menu_user_select = Read-Host "Please make a selection"
         switch ($sub_menu_user_select)
            {
               '1' {
                    Clear-Host
                    Write-Host "Please fill in the variables requested. You will be given a chance to review and retry before execution of upgrade."
                    $room_name = Read-Host "Please fill in the desired room name."
                    [string]$room_version = Read-Host "Please enter the desired room version." #Explicitly String declared because room versions are ALWAYS strings in matrix so why not. Yes they are strings even when they are "ints" like 10. Because v10 is also a valid room version its just the version we call v10 is actually called 10 in the JSON.
                    $powerlevel_string = Read-Host "Please enter the desired highest Powerlevel for users in the room at room creation. Spec default is 100. Recomended by FMA is 42000." #PL is refered to string here because we get a string from read host.
                    [int]$powerlevel = $powerlevel_string #This convert exists because Powerlevels are Always supposed to be intergers. This script will not support Interger PL in this mode. If you want to abuse your v9 rooms with Int PL i trust you to figure out to how make the script not cry and have fun with that.
                    $oldroom_ID = Read-Host "Please enter the room ID of the old room."
                    $alias_full = Read-Host "Please enter the alias for the room. This is purely visual and only relevant for the upgrade notice. The upgrade notice will contain a copy of the alias for easier migration for end users."
                    
                } '2' {
                    Clear-Host
                    Write-Host "Clearing Variables"
                    $room_name = $null
                    $room_version = $null
                    $powerlevel = $null
                    $powerlevel_string = $null
                    $oldroom_ID = $null
                    $alias_full = $null
                    $null = Read-Host "Enter any input and press enter to proceed. Or just press enter." #Writing to null here is a way to maintain cross platform due to that powershell does actually not have a easy cross platform way to pause a script outside of this. Pause is windows exclusive and actually launches a CMD program for those who didnt realise it. Since FMA is aiming to be cross platform that eliminates it from consideration.
                } 'ok' {
                    #Upgrade Notice event contents represented as PS Custom Object
                    $message_event_PSCustom = [PSCustomObject]@{
                        body = "<h3>This room is hereby being <em>tombstoned</em> and replaced with a new room.</h3> <p>Your client should provide a link to join the new room. If not, check the space room listing or use the direct address <code>$alias_full</code> to join.</p> <p><strong>FluffyChat is known to not handle tombstoning gracefully.</strong> Element desktop/mobile, SchildiChat desktop/mobile, and Cinny are known to work.</p> <p><em>In case of any unforeseen issues, please be patient and check here and the space room listing after a few minutes.</em></p>"
                        format = 'org.matrix.custom.html'
                        formatted_body = "<h3>This room is hereby being <em>tombstoned</em> and replaced with a new room.</h3> <p>Your client should provide a link to join the new room. If not, check the space room listing or use the direct address <code>$alias_full</code> to join.</p> <p><strong>FluffyChat is known to not handle tombstoning gracefully.</strong> Element desktop/mobile, SchildiChat desktop/mobile, and Cinny are known to work.</p> <p><em>In case of any unforeseen issues, please be patient and check here and the space room listing after a few minutes.</em></p>"
                        msgtype = "m.text"
                    }

                    #Turns the PS Custom Object into JSON
                    $message_event_JSON = ConvertTo-Json -InputObject $message_event_PSCustom -depth 100
                    #Generate TXID for the notice event.
                    $notice_txnid = "FMA"
                    $unixTime = Get-Date -Date ((Get-Date).ToUniversalTime()) -UFormat %s
                    $notice_txnid += $unixTime
                    #URI for the message event endpoint.
                    $uri_send_message = "https://$homeserver_url/_matrix/client/v3/rooms/$oldroom_ID/send/m.room.message/$notice_txnid"
                    #Sends the Upgrade Notice using the message event contained in $message_event_JSON.
                    $Notice_Event_ID = Invoke-RestMethod -Uri $uri_send_message -Method PUT -Headers @{Authorization=("Bearer $Access_Token")} -body $message_event_JSON -ContentType "application/json"
                    #New Rooms Create Event represented as PSCustomObject
                    $createevent_PSCustom = [PSCustomObject]@{
                        name = $room_name
                        room_version = $room_version
                        power_level_content_override = @{
                            users = @{
                                $username = [int]$powerlevel
                            }
                        }
                        creation_content = @{
                            predecessor = @{
                                room_id = $oldroom_ID
                                event_id = $Notice_Event_ID.event_id
                            }
                        }
                    }
    
                    #Turns the PS Custom Object into JSON
                    $createevent_JSON = ConvertTo-Json -InputObject $createevent_PSCustom -depth 100
                    #URIs needed by this function sits here because its after the input stage and we need to be post input stage to have access to old room ID.
                    $uri_createroom = "https://$homeserver_url/_matrix/client/v3/createRoom"
                    #Creates the New Room using the JSON in Custom Object Format above.
                    $createresponse = Invoke-RestMethod -Uri $uri_createroom -Method POST -Headers @{Authorization=("Bearer $Access_Token")} -body $createevent_JSON -ContentType "application/json"
                    #Tombstone represented as PS Custom Object. Sits here because its AFTER we have the required data.
                    $oldroomtombstone_PSCustom = [PSCustomObject]@{
                    replacement_room = $createresponse.room_id
                    }
                    #Tombstone turned from PS Custom to JSON.
                    $oldroomtombstone_JSON = ConvertTo-Json -InputObject $oldroomtombstone_PSCustom -depth 100
                    #Tombstone URI
                    $uri_tombstone = "https://$homeserver_url/_matrix/client/v3/rooms/$oldroom_ID/state/m.room.tombstone"
                    #Sends the Tombstone into the old room completing the chain.
                    Invoke-RestMethod -Uri $uri_tombstone -Method PUT -Headers @{Authorization=("Bearer $Access_Token")} -body $oldroomtombstone_JSON -ContentType "application/json"
                    Write-Host "Creation and linking of rooms completed. To complete the upgrade complete any manual transfers you desire to do."
                    $null = Read-Host "Enter any input and press enter to proceed. Or just press enter."
                    $sub_menu_user_select = 'q'
                    return
                } 'q' {
                    return
                }
            }
    }
    until ($sub_menu_user_select -eq 'q')
}
Function Manual_Tombstone {
    #Making all the variables Null here to make sure they are ALWAYS empty upon initialisation of this function. This is probably not needed but still cant hurt to be too sure. We can always clean this up later.
    $oldroom_ID = $null
    $newroom_ID = $null
    do
    {   
        Clear-Host
        Write-Host "================ Current Variable States ================"
        Write-Host "Current Access Token is: $Access_token"
        Write-Host "Current homeserver URL is: $homeserver_url"
        Write-Host "Selected Room ID for Tombstone Target is: $oldroom_ID"
        Write-Host "Selected Selected Replacement Room ID is: $newroom_ID"
        Write-Host "================ Warnings and Disclaimers ================"
        Write-Host "Warning about Tombstones. Unless the replacement room has a predecessor in its creation content clients will become unhappy potentially."
        Write-Host "This option exists for use by users who know what they are doing. This warning is repeated even tho this warning applies to this whole tool. Its for advanced users who know what they are doing."
        Write-Host "================ Manual Tombstone Variable Selection ================"
        Write-Host "1: Press '1' to configure Variables."
        Write-Host "2: Press '2' to Erase Variables."
        Write-Host "ok: Write 'ok' to tombstone the selected room and point to its replacement manually."
        Write-Host "q: Press 'q' to exit to main menu without tombstoning room."
         $sub_menu_user_select = Read-Host "Please make a selection"
         switch ($sub_menu_user_select)
            {
               '1' {
                    Clear-Host
                    Write-Host "Please fill in the variables requested. You will be given a chance to review and retry before execution of upgrade."
                    $oldroom_ID = Read-Host "Please enter the room ID of the old room."
                    $newroom_ID = Read-Host "Please enter the room ID for the Tombstone Target."
                } '2' {
                    Clear-Host
                    Write-Host "Clearing Variables"
                    $oldroom_ID = $null
                    $newroom_ID = $null
                    $null = Read-Host "Enter any input and press enter to proceed. Or just press enter." #Writing to null here is a way to maintain cross platform due to that powershell does actually not have a easy cross platform way to pause a script outside of this. Pause is windows exclusive and actually launches a CMD program for those who didnt realise it. Since FMA is aiming to be cross platform that eliminates it from consideration.
                } 'ok' {
                    $uri_tombstone = "https://$homeserver_url/_matrix/client/v3/rooms/$oldroom_ID/state/m.room.tombstone"
                    #Tombstone represented as PS Custom Object. Sits here because its AFTER we have the required data.
                    $oldroomtombstone_PSCustom = [PSCustomObject]@{
                    replacement_room = $newroom_ID
                    }
                    #Tombstone turned from PS Custom to JSON.
                    $oldroomtombstone_JSON = ConvertTo-Json -InputObject $oldroomtombstone_PSCustom -depth 100
                    #Sends the Tombstone into the old room completing the chain.
                    Invoke-RestMethod -Uri $uri_tombstone -Method PUT -Headers @{Authorization=("Bearer $Access_Token")} -body $oldroomtombstone_JSON -ContentType "application/json"
                    Write-Host "Tombstone has been sent."
                    $null = Read-Host "Enter any input and press enter to proceed. Or just press enter."
                    $sub_menu_user_select = 'q'
                    return
                } 'q' {
                    return
                }
            }
    }
    until ($sub_menu_user_select -eq 'q')
}
Function Manual_Tombstone_With_Notice {
    #Making all the variables Null here to make sure they are ALWAYS empty upon initialisation of this function. This is probably not needed but still cant hurt to be too sure. We can always clean this up later.
    $oldroom_ID = $null
    $newroom_ID = $null
    $alias_full = $null
    do
    {   
        Clear-Host
        Write-Host "================ Current Variable States ================"
        Write-Host "Current Access Token is: $Access_token"
        Write-Host "Current homeserver URL is: $homeserver_url"
        Write-Host "Selected Room ID for Tombstone Target is: $oldroom_ID"
        Write-Host "Selected Selected Replacement Room ID is: $newroom_ID"
        Write-Host "================ Warnings and Disclaimers ================"
        Write-Host "Warning about Tombstones. Unless the replacement room has a predecessor in its creation content clients will become unhappy potentially."
        Write-Host "This option exists for use by users who know what they are doing. This warning is repeated even tho this warning applies to this whole tool. Its for advanced users who know what they are doing."
        Write-Host "================ Manual Tombstone Variable Selection ================"
        Write-Host "1: Press '1' to configure Variables."
        Write-Host "2: Press '2' to Erase Variables."
        Write-Host "ok: Write 'ok' to tombstone the selected room and point to its replacement manually."
        Write-Host "q: Press 'q' to exit to main menu without tombstoning room."
         $sub_menu_user_select = Read-Host "Please make a selection"
         switch ($sub_menu_user_select)
            {
               '1' {
                    Clear-Host
                    Write-Host "Please fill in the variables requested. You will be given a chance to review and retry before execution of upgrade."
                    $oldroom_ID = Read-Host "Please enter the room ID of the old room."
                    $newroom_ID = Read-Host "Please enter the room ID for the Tombstone Target."
                    $alias_full = Read-Host "Please enter the alias for the room. This is purely visual and only relevant for the upgrade notice. The upgrade notice will contain a copy of the alias for easier migration for end users."
                } '2' {
                    Clear-Host
                    Write-Host "Clearing Variables"
                    $oldroom_ID = $null
                    $newroom_ID = $null
                    $alias_full = $null
                    $null = Read-Host "Enter any input and press enter to proceed. Or just press enter." #Writing to null here is a way to maintain cross platform due to that powershell does actually not have a easy cross platform way to pause a script outside of this. Pause is windows exclusive and actually launches a CMD program for those who didnt realise it. Since FMA is aiming to be cross platform that eliminates it from consideration.
                } 'ok' {
                    #Upgrade Notice event contents represented as PS Custom Object
                    $message_event_PSCustom = [PSCustomObject]@{
                        body = "<h3>This room is hereby being <em>tombstoned</em> and replaced with a new room.</h3> <p>Your client should provide a link to join the new room. If not, check the space room listing or use the direct address <code>$alias_full</code> to join.</p> <p><strong>FluffyChat is known to not handle tombstoning gracefully.</strong> Element desktop/mobile, SchildiChat desktop/mobile, and Cinny are known to work.</p> <p><em>In case of any unforeseen issues, please be patient and check here and the space room listing after a few minutes.</em></p>"
                        format = 'org.matrix.custom.html'
                        formatted_body = "<h3>This room is hereby being <em>tombstoned</em> and replaced with a new room.</h3> <p>Your client should provide a link to join the new room. If not, check the space room listing or use the direct address <code>$alias_full</code> to join.</p> <p><strong>FluffyChat is known to not handle tombstoning gracefully.</strong> Element desktop/mobile, SchildiChat desktop/mobile, and Cinny are known to work.</p> <p><em>In case of any unforeseen issues, please be patient and check here and the space room listing after a few minutes.</em></p>"
                        msgtype = "m.text"
                    }
                    #Turns the PS Custom Object into JSON
                    $message_event_JSON = ConvertTo-Json -InputObject $message_event_PSCustom -depth 100
                    #Generate TXID for the notice event.
                    $notice_txnid = "FMA"
                    $unixTime = Get-Date -Date ((Get-Date).ToUniversalTime()) -UFormat %s
                    $notice_txnid += $unixTime
                    #URI for the message event endpoint.
                    $uri_send_message = "https://$homeserver_url/_matrix/client/v3/rooms/$oldroom_ID/send/m.room.message/$notice_txnid"
                    #Sends the Upgrade Notice using the message event contained in $message_event_JSON.
                    Invoke-RestMethod -Uri $uri_send_message -Method PUT -Headers @{Authorization=("Bearer $Access_Token")} -body $message_event_JSON -ContentType "application/json"
                    $uri_tombstone = "https://$homeserver_url/_matrix/client/v3/rooms/$oldroom_ID/state/m.room.tombstone"
                    #Tombstone represented as PS Custom Object. Sits here because its AFTER we have the required data.
                    $oldroomtombstone_PSCustom = [PSCustomObject]@{
                    replacement_room = $newroom_ID
                    }
                    #Tombstone turned from PS Custom to JSON.
                    $oldroomtombstone_JSON = ConvertTo-Json -InputObject $oldroomtombstone_PSCustom -depth 100
                    #Sends the Tombstone into the old room completing the chain.
                    Invoke-RestMethod -Uri $uri_tombstone -Method PUT -Headers @{Authorization=("Bearer $Access_Token")} -body $oldroomtombstone_JSON -ContentType "application/json"
                    Write-Host "Tombstone has been sent."
                    $null = Read-Host "Enter any input and press enter to proceed. Or just press enter."
                    $sub_menu_user_select = 'q'
                    return
                } 'q' {
                    return
                }
            }
    }
    until ($sub_menu_user_select -eq 'q')
}
Function Custom_Powerlevel_Room {
    #Making all the variables Null here to make sure they are ALWAYS empty upon initialisation of this function. This is probably not needed but still cant hurt to be too sure. We can always clean this up later.
    $room_name = $null
    $room_version = $null
    $powerlevel = $null
    $powerlevel_string = $null
    do
    {   
        Clear-Host
        Write-Host "================ Current Variable States ================"
        Write-Host "Current Access Token is: $Access_token"
        Write-Host "Current homeserver URL is: $homeserver_url"
        Write-Host "Room name is set to: $room_name"
        Write-Host "Currently selected room version is: $room_version"
        Write-Host "PL for $username is $powerlevel."
        Write-Host "================ Custom Powerlevel Variable Selection ================"
        Write-Host "1: Press '1' to configure Variables."
        Write-Host "2: Press '2' to Erase Variables."
        Write-Host "ok: Write 'ok' to Create Custom Powerlevel room."
        Write-Host "q: Press 'q' to exit to main menu without creating a room."
         $sub_menu_user_select = Read-Host "Please make a selection"
         switch ($sub_menu_user_select)
            {
               '1' {
                    Clear-Host
                    Write-Host "Please fill in the variables requested. You will be given a chance to review and retry before execution of upgrade."
                    $room_name = Read-Host "Please fill in the desired room name."
                    [string]$room_version = Read-Host "Please enter the desired room version." #Explicitly String declared because room versions are ALWAYS strings in matrix so why not. Yes they are strings even when they are "ints" like 10. Because v10 is also a valid room version its just the version we call v10 is actually called 10 in the JSON.
                    $powerlevel_string = Read-Host "Please enter the desired highest Powerlevel for users in the room at room creation. Spec default is 100. Recomended by FMA is 42000." #PL is refered to string here because we get a string from read host.
                    [int]$powerlevel = $powerlevel_string #This convert exists because Powerlevels are Always supposed to be intergers. This script will not support Interger PL in this mode. If you want to abuse your v9 rooms with Int PL i trust you to figure out to how make the script not cry and have fun with that.                    
                } '2' {
                    Clear-Host
                    Write-Host "Clearing Variables"
                    $room_name = $null
                    $room_version = $null
                    $powerlevel = $null
                    $powerlevel_string = $null
                    $null = Read-Host "Enter any input and press enter to proceed. Or just press enter." #Writing to null here is a way to maintain cross platform due to that powershell does actually not have a easy cross platform way to pause a script outside of this. Pause is windows exclusive and actually launches a CMD program for those who didnt realise it. Since FMA is aiming to be cross platform that eliminates it from consideration.
                } 'ok' {
                    #New Rooms Create Event represented as PSCustomObject
                    $createevent_PSCustom = [PSCustomObject]@{
                        name = $room_name
                        room_version = $room_version
                        power_level_content_override = @{
                            users = @{
                                $username = [int]$powerlevel
                            }
                        }
                    }
    
                    #Turns the PS Custom Object into JSON
                    $createevent_JSON = ConvertTo-Json -InputObject $createevent_PSCustom -depth 100
                    #URIs needed by this function sits here because its after the input stage and we need to be post input stage to have access to old room ID.
                    $uri_createroom = "https://$homeserver_url/_matrix/client/v3/createRoom"
                    #Creates the New Room using the JSON in Custom Object Format above.
                    Invoke-RestMethod -Uri $uri_createroom -Method POST -Headers @{Authorization=("Bearer $Access_Token")} -body $createevent_JSON -ContentType "application/json"
                    Write-Host "Creation of Custom Powerlevel room is done."
                    $null = Read-Host "Enter any input and press enter to proceed. Or just press enter."
                    $sub_menu_user_select = 'q'
                    return
                } 'q' {
                    return
                }
            }
    }
    until ($sub_menu_user_select -eq 'q') 
}
#Main menu loop
do
{
     Show-Main-Menu
     $userselection = Read-Host "Please make a selection"
     switch ($userselection)
     {
           '1' {
             Manual_Upgrade
           } '2' {
             Manual_Upgrade_With_Notice
#           } '3' {
#             Clear-Host
#           } '4' {
#             Clear-Host
#             Enable_Allow_ICMP
           } '5' {
            Manual_Tombstone
           } '6' {
            Manual_Tombstone_With_Notice
           } '7' {
            Custom_Powerlevel_Room
#           } '8' {
#            Clear-Host
#            Disable_Firewall
#           } '9' {
#            Clear-Host
#            Disable_Firewall
           } 'q' {
                return
           }
     }
}
until ($userselection -eq 'q')