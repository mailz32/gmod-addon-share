if game.IsDedicated() then
    addonshare.DesiredFilter = addonshare.FilterByContent
else
    addonshare.DesiredFilter = addonshare.FilterByTags
end

addonshare.Filtered = addonshare.DesiredFilter( addonshare.Addons )
for _, addon in ipairs( addonshare.Filtered ) do
    resource.AddWorkshop( addon.wsid )
end

hook.Add("PlayerInitialSpawn", addonshare.HOOK_ADDONSHARE_SEND_TABLE,
         addonshare.SendTable)
