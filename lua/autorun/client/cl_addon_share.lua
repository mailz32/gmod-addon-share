net.Receive("addonshare_addons_table", function()
	AS_AddonsTable = net.ReadTable()
end)

local categoryIcons = {
	["Effects"] = "icon16/image.png",
	["Entity"] = "icon16/bomb.png",
	["Gamemode"] = "icon16/controller.png",
	["map"] = "icon16/map.png",
	["model"] = "icon16/sport_soccer.png",
	["NPC"] = "icon16/monkey.png",
	["tool"] = "icon16/wrench.png",
	["Vehicle"] = "icon16/car.png",
	["Weapon"] = "icon16/gun.png"
}

local function addToMenu(Parent, wsid, category, title, mounted)
	local panel = vgui.Create("DPanel", Parent)
	panel:SetHeight(20)
	if mounted then
		panel:SetPaintBackground(false)
	end
	panel:Dock(TOP)
	panel:DockMargin(2, 2, 0, 2)

	local iconSubscribed = vgui.Create("DImage", panel)
	iconSubscribed:SetImage(steamworks.IsSubscribed(wsid) and "icon16/plugin.png" or "icon16/plugin_disabled.png")
	iconSubscribed:SetSize(16, 16)
	iconSubscribed:SetKeepAspect(true)
	iconSubscribed:Dock(LEFT)
	iconSubscribed:DockMargin(2, 2, 2, 2)

	local iconCategory = vgui.Create("DImage", panel)
	iconCategory:SetImage(categoryIcons[category] or "icon16/page_white.png")
	iconCategory:SetKeepAspect(true)
	iconCategory:Dock(LEFT)
	iconCategory:DockMargin(2, 2, 2, 2)
	iconCategory:SetSize(16, 16)

	local buttonWorkshop = vgui.Create("DButton", panel)
	buttonWorkshop:SetText("WS")
	buttonWorkshop:SizeToContents()
	buttonWorkshop.DoClickInternal = function() steamworks.ViewFile(wsid)  end
	buttonWorkshop:Dock(LEFT)
	buttonWorkshop:DockMargin(2, 2, 4, 2)

	local label = vgui.Create("DLabel", panel)
	label:SetText(title)
	label:SetDark(true)
	label:Dock(FILL)
end

local function addonMenu(Panel)
	Panel:SetName("List of serverside addons ("..#AS_AddonsTable..")")
	if not AS_AddonsTable then
		Panel:Help("Error occurred while receiving addons data from server. Has server 'Addon Share' installed?")
		return nil
	end
	Panel:Help("Marked addons are disabled.\nHit [WS] button to open addon's workshop page.\nSubscription status will update on map change.")
	for _, entry in pairs(AS_AddonsTable) do
		local category = entry.tags:match(",(%a+)") -- extracts second value from tags, separated by commas, which is addon's category
		addToMenu(Panel, entry.wsid, category, entry.title, entry.mounted)
	end
end


hook.Add("PopulateToolMenu", "Addon Share menu", function ()
	spawnmenu.AddToolMenuOption("Utilities", "Addon Share", "Addon_Share", "Addons", "", "", addonMenu)
end)
