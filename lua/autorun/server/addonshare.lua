-- Include respective files for server and client

if game.SinglePlayer() then return end

include( 'addonshare/structure.lua' )
include( 'addonshare/server/file.lua' )
include( 'addonshare/server/network.lua' )

if game.IsDedicated() then
		addonshare.DesiredFilter = addonshare.FilterByContent
else
		addonshare.DesiredFilter = addonshare.FilterByTags
end
