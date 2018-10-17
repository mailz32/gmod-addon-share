-- Include respective files for server and client

if game.SinglePlayer() then
    MsgN( "[Addon Share] Not running because in single player" )
    return
end

AddCSLuaFile( 'addonshare/client/init.lua' )
AddCSLuaFile( 'addonshare/client/network.lua' )
AddCSLuaFile( 'addonshare/structure.lua' )

include( 'addonshare/structure.lua' ) -- make this first
include( 'addonshare/server/file.lua' )
include( 'addonshare/server/network.lua' )
include( 'addonshare/server/init.lua' ) -- make this last
