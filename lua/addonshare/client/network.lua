-- Receive addons list

--[[
	table list = function addonshare.UnpackList()
Returns:
	* list - table of addons with only wsid field set
Supposed to retrieve up to 8192 UInt values
--]]
function addonshare.UnpackList()
		local wsid
		local counter = 0
		local list = {}
		while counter < 8192 do
				wsid = net.ReadUInt( 32 )
				if wsid == 0 then break end
				table.insert( list, { ['wsid'] = wsid } )
				counter = counter + 1
		end
		return list
end

--[[
	table completed = function addonshare.RetrieveAddonsInfo( table addons )
Takes:
	* addons - table of addons, which require info update
Returns:
	* completed - table of addons with all requested info
Warning! Table "completed" may not be filled right after running this function,
it takes time to request addon info and process responce.
--]]
function addonshare.RetrieveAddonsInfo( addons )
	local completed = {}
	for i, addon in ipairs( addons ) do
		steamworks.FileInfo( addon.wsid,
			function ( result )
				table.insert( completed, result )
			end)
	end
	return completed
end

-- Just a wrapper for previous functions, look above
function addonshare.ReceiveList()
		local list = addonshare.UnpackList()
		addonshare.Addons = addonshare.RetrieveAddonsInfo( list )
end

--net.Receive( addonshare.NET_ADDONSHARE_TABLE, addonshare.ReceiveList )
