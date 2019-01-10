if game.SinglePlayer() then
    return
end

-- Convars
CreateConVar("addonshare_auto", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Should 'Addon Share' automatically pick addons to download?")
CreateConVar("addonshare_send_maps", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Should 'Addon Share' send all maps to client's list too? (Just list entries, not actually a files)")

-- Concmd
concommand.Add("addonshare_manual", function (ply, cmd, args)
    local id = tonumber( args[1] )
    if id then
        resource.AddWorkshop( id )
        MsgN("[Addon Share] Manually added an addon with ID " .. id)
    end
end, function () end,
"Specify extra addon to be downloaded by client. Use 'id' number from Workshop addon page URI (link)", FCVAR_SERVER_CAN_EXECUTE)

local AddonsTable = {}
for _, i in ipairs(engine.GetAddons()) do
    local entry = {title=i.title, wsid=i.wsid}
    entry.category = i.tags:match(",(%a+)") -- extracts second value from tags, separated by commas, which is addon's category
    if (entry.category != "map" or
        GetConVar("addonshare_send_maps"):GetBool()) 
    then
        table.insert(AddonsTable, entry)
    end
end

AS_DataToSend = util.Compress(util.TableToJSON(AddonsTable))

-- Sendint table to client after spawning
util.AddNetworkString("addonshare_addons_table")
hook.Add("PlayerInitialSpawn", "Addon Share send table", function(ply)
    local startpos = 0
    local msg_len = 0
    local last_msg = false
    while not last_msg do
        msg_len = math.min(65530, #AS_DataToSend - startpos)
        last_msg = startpos + msg_len == #AS_DataToSend
        net.Start("addonshare_addons_table")
        net.WriteBool(last_msg)
        net.WriteUInt(msg_len, 16)
        net.WriteData(string.sub(AS_DataToSend, startpos, startpos + msg_len), msg_len)
        net.Send(ply)
        startpos = startpos + msg_len
    end
end)

-- AddWorkshop job

if GetConVar("addonshare_auto"):GetBool() then
	local counter = 0
	for _, entry in ipairs(engine.GetAddons()) do
		if entry.mounted and entry.models > 0 and not entry.tags:find( 'map' ) then
			resource.AddWorkshop( entry.wsid )
			counter = counter + 1
		end
	end
	MsgN("[Addon Share] Auto added "..counter.." addons for clients to download on connect")
else
	MsgN("[Addon Share] Nothing will be auto added to dependencies for clients due to 'addonshare_auto 0'")
end
