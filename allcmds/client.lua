addEvent("allcmds-all", true)
addEvent("allcmds-specific", true)

local function allcommands(allowed)
    if allowed ~= true then
        return triggerServerEvent("allcmdsclient", localPlayer, "all")
    end
    local results = {nil}

    for _, cmd in ipairs( getCommandHandlers() ) do
        local commandName = cmd[1]
        local theResource = cmd[2]
        results[theResource] = results[theResource] or {}
        table.insert(results[theResource], commandName)
    end

    outputChatBox( CLIENT_LIST_START, 255, 255, 255, true )
    for res, cmds in pairs( results ) do
        local resource = getResourceName( res )
        local resourceState = getResourceState(res)
        outputChatBox( "\n#bf8e39▂▂▌ #ebe2d8"..resource.." #bf8e39(#ebe2d8"..tostring(resourceState or false).."#bf8e39)", 255, 255, 255, true )
        for _, cmd in ipairs( cmds ) do
            outputChatBox( "  • #bf8e39/#e8e2dc"..cmd, 255, 255, 255, true )
        end
    end
    outputChatBox( CLIENT_LIST_FINAL, 255, 255, 255, true )

end
addCommandHandler("clientallcmds", allcommands)
addEventHandler("allcmds-all", localPlayer, allcommands)

local function commands(allowed, resourceName)
    if allowed ~= true then
        return triggerServerEvent("allcmdsclient", localPlayer, "specific", tostring(resourceName))
    end
    local resource = (resourceName and getResourceFromName(resourceName)) or resource
    local resourceState = getResourceState(resource)
    outputChatBox( "\n#bf8e39▂▂▌ #ebe2d8"..getResourceName(resource).." #bf8e39(#ebe2d8"..tostring(resourceState or false).."#bf8e39)", 255, 255, 255, true )
    local cmds = getCommandHandlers( resource )

    if #cmds > 0 then
        for _, cmd in ipairs( cmds ) do
            outputChatBox( "  • #bf8e39/#e8e2dc"..cmd, 255, 255, 255, true )
        end
        outputChatBox(" ")
    else
        outputChatBox( "Aparentemente essa resource não tem nenhum comando.", 255, 255, 255, true )
    end

end
addCommandHandler("clientcmd", commands)
addEventHandler("allcmds-specific", localPlayer, commands)