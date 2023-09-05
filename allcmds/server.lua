addEvent( "allcmdsclient", true )

local function isPlayerInACL(player, acl)
	if isElement(player) and getElementType(player) == "player" and aclGetGroup(acl or "") then
		local acc = getPlayerAccount(player)
        return isObjectInACLGroup( "user.".. getAccountName(acc), aclGetGroup(acl) )
	end
	return false
end

local function clientrequest(type, resource)
    if not client then
        return
    end
    if not (isPlayerInACL(client, "Console") or isPlayerInACL(client, "Admin") or isPlayerInACL(client, "SuperModerator")) then
        return
    end
    if type == "specific" and resource then
        triggerClientEvent(client, "allcmds-specific", client, true, resource)
    elseif type == "all" then
        triggerClientEvent(client, "allcmds-all", client, true)
    end
end
addEventHandler( "allcmdsclient", root, clientrequest )

local function allcommands(player)
    if not (isPlayerInACL(player, "Console") or isPlayerInACL(player, "Admin") or isPlayerInACL(player, "SuperModerator")) then
        return
    end
    local results = {}

    for _, cmd in ipairs( getCommandHandlers() ) do
        local commandName = cmd[1]
        local theResource = cmd[2]
        results[theResource] = results[theResource] or {}
        table.insert(results[theResource], commandName)
    end

    outputChatBox( SERVER_LIST_START, player, 255, 255, 255, true )
    for res, cmds in pairs( results ) do
        local resource = getResourceInfo( res, "name" ) or getResourceName( res )
        local state = getResourceState(res)
        outputChatBox( "\n#395dbf▂▂▌ #d8ddeb"..resource.." #395dbf(#d8ddeb"..tostring(state).."#395dbf)", player, 255, 255, 255, true )
        for _, cmd in ipairs( cmds ) do
            outputChatBox( "  • #395dbf/#dce0e8"..cmd, player, 255, 255, 255, true )
        end
    end
    outputChatBox( SERVER_LIST_FINAL, player, 255, 255, 255, true )

end
addCommandHandler("allcmds", allcommands)

local function commands( player, _, resourceName)
    if not (isPlayerInACL(player, "Console") or isPlayerInACL(player, "Admin") or isPlayerInACL(player, "SuperModerator")) then
        return
    end
    local resource = (resourceName and getResourceFromName(resourceName)) or resource
    local state = getResourceState(resource)
    outputChatBox( " ", player, 255, 255, 255, true )
    outputChatBox( "\n#395dbf▂▂▌ #d8ddeb"..getResourceName(resource).." #395dbf(#d8ddeb"..tostring(state).."#395dbf)", player, 255, 255, 255, true )

    local cmds = getCommandHandlers( resource )
    if #cmds > 0 then
        for _, cmd in ipairs( cmds ) do
            outputChatBox( "  • #395dbf/#dce0e8"..cmd, player, 255, 255, 255, true )
        end
        outputChatBox( " ", player)
    else
        outputChatBox( "Aparentemente essa resource não tem nenhum comando, tente /clientcmd "..getResourceName(resource), player, 255, 255, 255, true )
    end

end
addCommandHandler("cmd", commands)

local function cmdHelp(player)
    if not (isPlayerInACL(player, "Console") or isPlayerInACL(player, "Admin") or isPlayerInACL(player, "SuperModerator")) then
        return
    end
    outputChatBox( " ", player)
    outputChatBox( "Comandos:", player, 255, 255, 255, true )
    outputChatBox( "  Lado do Servidor:", player, 255, 255, 255, true )
    outputChatBox( "    • #395dbf/#dce0e8cmd nome-da-resource", player, 255, 255, 255, true )
    outputChatBox( "    • #395dbf/#dce0e8allcmds", player, 255, 255, 255, true )
    outputChatBox( "  Lado do Jogador:", player, 255, 255, 255, true )
    outputChatBox( "    • #bf8e39/#e8e2dcclientcmd nome-da-resource", player, 255, 255, 255, true )
    outputChatBox( "    • #bf8e39/#e8e2dcclientallcmds", player, 255, 255, 255, true )
    outputChatBox( " ", player)
end
addCommandHandler("cmdhelp", cmdHelp)