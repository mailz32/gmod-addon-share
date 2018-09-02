-- Describes addon table structure and methods

-- Addon's namespace
addonshare = {
	_VERSION = 0.2,
	Addons = engine.GetAddons(),
	HOOK_ADDONSHARE_SEND_TABLE = 'AddonShare_send_table',
	NET_ADDONSHARE_TABLE = 'AddonShare_table'
	--NET_ADDONSHARE_SETTINGS = 'AddonShare_settings'
}

--[[
	table filtered = function addonshare.FilterByTags( table addons )
Takes:
	* addons - table of addons, structured like engine.GetAddons()
Returns:
	* filtered - table of addons, filtered by models count and tags
--]]
function addonshare.FilterByTags( addons )
	local filtered = {}
	for _, addon in ipairs( addons ) do
		if not string.find( addon.tags, 'map' ) and
		   string.find( addon.tags, 'model' ) or
		   addon.models
		then
			table.insert( filtered, addon )
		end
	end
	return filtered
end
