addonshare.Addons = engine.GetAddons()

addonshare.Mounted = addonshare.FilterByTags( addonshare.Addons )
addonshare.Filtered = addonshare.FilterByContent( addonshare.Mounted )

for _, addon in ipairs( addonshare.Filtered ) do
    resource.AddWorkshop( addon.wsid )
end

addonshare.log( "Added " .. #addonshare.Filtered .. " workshop dependencies" )

hook.Add("PlayerInitialSpawn", addonshare.HOOK_ADDONSHARE_SEND_TABLE,
         addonshare.SendTable)
