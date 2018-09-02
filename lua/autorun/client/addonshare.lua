-- Include respective files for client

if game.SinglePlayer() then return end

include( 'addonshare/structure.lua' ) -- make this first
include( 'addonshare/client/network.lua' )
include( 'addonshare/client/init.lua' ) -- make this last
