-- Describes addon table structure and methods

-- Addon's namespace
addonshare = {
    _VERSION = 0.2,
    HOOK_ADDONSHARE_SEND_TABLE = 'AddonShare_send_table',
    NET_ADDONSHARE_TABLE = 'AddonShare_table'
    --NET_ADDONSHARE_SETTINGS = 'AddonShare_settings'
}

--[[
    table filtered = function addonshare.FilterByTags( table addons )
Takes:
    * addons - table of addons, structured like engine.GetAddons()
Returns:
    * filtered - table of addons, filtered by models count --and tags
--]]
function addonshare.FilterByTags( addons )
    local filtered = {}
    for _, addon in ipairs( addons ) do
        if  addon.mounted
            and not string.find( addon.tags, 'map' )
            --and addon.models > 0
        then
            table.insert( filtered, addon )
        end
    end
    return filtered
end

function addonshare.log( message )
    MsgN( "[Addon Share] " .. message )
end
