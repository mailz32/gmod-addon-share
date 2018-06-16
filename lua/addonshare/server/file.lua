-- Scanning addons' contents, saving configuration

--[[
	table filtered = function addonshare.FilterByContent( table addons )
Takes:
	* addons - table of addons, structured like engine.GetAddons()
Returns:
	* filtered - table of addons, that contain models, materials, etc, but not
	             maps (in gmod current map will always added to resources)
Warning! file.Find feature, that allows to view GMA's content, is labeled as
deprecated!
--]]
function addonshare.FilterByContent( addons )
	local BLACKLIST = {
		bsp = true
	}
	local WHITELIST = {
		bsp = true, jpeg = true, jpg = true,  png = true,  vmt = true,
		vtf = true, ani = true,  mdl = true,  phy = true,  vtx = true,
		vvd = true,  pcf = true, ttf = true,  vcd = true,  mp3 = true,
		ogg = true, wav = true
	}
	local filtered = {}

	local function explore( addon_title, parent )
		local mask = parent and parent .. '/*' or '*'
		local files, dirs = file.Find( mask, addon_title )
		for _, dir in ipairs(dirs) do
			-- Tail recursion here!
			for _, file in ipairs( explore( addon_title, parent and parent..'/'..dir or dir ) ) do
				table.insert( files, file )
			end
		end
		return files
	end

	for _, addon in ipairs( addons ) do
		local addon_files = explore ( addon.title )
		local allow = false

		for _, file in ipairs(addon_files) do
			local ext = string.GetExtensionFromFilename( file )
			if BLACKLIST[ext] then allow = false break end
			allow = allow or WHITELIST[ext]
		end

		if allow then table.insert( filtered, addon ) end
	end
	return filtered
end
