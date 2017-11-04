AS_AddonsTable = engine.GetAddons()
AS_AddonsTable.version = 0.1

-- Sendint table to client after spawning
util.AddNetworkString("addonshare_addons_table")
hook.Add("PlayerInitialSpawn", "Addon Share send table", function(ply)
	net.Start("addonshare_addons_table")
	net.WriteTable(AS_AddonsTable)
	net.Send(ply)
end)

-- AddWorkshop job
CreateConVar("addonshare_dependencies", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Should 'Addon Share' force connecting players to download addons, that contain models?")

if GetConVar("addonshare_dependencies"):GetBool() then
	local counter = 0
	for _, entry in pairs(AS_AddonsTable) do
		if entry.mounted and entry.models > 0 and not entry.tags:find( 'map' ) then
			resource.AddWorkshop( entry.wsid )
			counter = counter + 1
		end
	end
	MsgN("[Addon Share] Added "..counter.." addons for clients to download on connect")
else
	MsgN("[Addon Share] Nothing will be added to dependencies for clients due to 'addonshare_dependencies 0'")
end
