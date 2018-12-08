-- Send addons list

--[[
	function adonshare.SendTable( Player player )
Takes:
	* player - entity object of a newly joined player
Sends addons' wsids as UInt values
--]]
function addonshare.SendTable( player )
		local count = math.min( #addonshare.Mounted, 16382 )
		net.Start( addonshare.NET_ADDONSHARE_TABLE )
		net.WriteUInt( count, 32 )
		for i = 1, count do
				net.WriteUInt( addonshare.Addons[i].wsid, 32 )
		end
		net.Send( player )
end

util.AddNetworkString( addonshare.NET_ADDONSHARE_TABLE )
--util.AddNetworkString( addonshare.NET_ADDONSHARE_SETTINGS )

