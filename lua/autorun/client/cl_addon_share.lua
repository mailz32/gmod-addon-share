if game.SinglePlayer() then
    return
end

net.Receive("addonshare_addons_table", function()
    AS_ReceivedData = AS_ReceivedData or ""
    local msg_len = 0
    local last_msg = false
    last_msg = net.ReadBool()
    msg_len = net.ReadUInt(16)
    AS_ReceivedData = AS_ReceivedData .. net.ReadData(msg_len)
    if last_msg then
        AS_AddonsTable = util.JSONToTable(util.Decompress(AS_ReceivedData))
        table.sort(AS_AddonsTable, function(l, r) return l.title < r.title end)
        AS_ReceivedData = nil
    end
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

local function addToMenu(Parent, Entry, Previous)
	local panel = vgui.Create("DPanel", Parent)
	panel:SetHeight(20)
    panel:SetPaintBackground(false)
	panel:Dock(TOP)
	panel:DockMargin(2, 2, 0, 2)
    if Previous then
        panel:MoveBelow(Previous)
    end

	local iconSubscribed = vgui.Create("DImage", panel)
	iconSubscribed:SetImage(steamworks.IsSubscribed(Entry.wsid) and "icon16/plugin.png" or "icon16/plugin_disabled.png")
	iconSubscribed:SetSize(16, 16)
	iconSubscribed:SetKeepAspect(true)
	iconSubscribed:Dock(LEFT)
	iconSubscribed:DockMargin(2, 2, 2, 2)

	local iconCategory = vgui.Create("DImage", panel)
    if title == "Addon Share" then
        iconCategory:SetImage("icon16/star.png")
    else
        iconCategory:SetImage(categoryIcons[Entry.category] or "icon16/page_white.png")
    end
	iconCategory:SetKeepAspect(true)
	iconCategory:Dock(LEFT)
	iconCategory:DockMargin(2, 2, 2, 2)
	iconCategory:SetSize(16, 16)

	local buttonWorkshop = vgui.Create("DButton", panel)
	buttonWorkshop:SetText("WS")
	buttonWorkshop:SizeToContents()
	buttonWorkshop.DoClickInternal = function() steamworks.ViewFile(Entry.wsid)  end
	buttonWorkshop:Dock(LEFT)
	buttonWorkshop:DockMargin(2, 2, 4, 2)

	local label = vgui.Create("DLabel", panel)
	label:SetText(Entry.title)
	label:SetDark(true)
	label:Dock(FILL)

    return panel
end

local function addonMenu(Panel)
	Panel:SetName("Addon Share")
	if not AS_AddonsTable then
		Panel:Help("Error occurred while receiving addons data from server. Has server 'Addon Share' installed?")
		return nil
	end
	if #AS_AddonsTable == 0 then
		Panel:Help("Looks like this server has no Workshop addons installed")
		return nil
	end
	Panel:SetName("List of serverside addons ("..#AS_AddonsTable..")")
	Panel:Help("Hit [WS] button to open addon's workshop page.\nGreen puzzle icon means you're subscribed for that.\nSubscription status will update on map change.")
    local prev
	for _, entry in ipairs(AS_AddonsTable) do
		prev = addToMenu(Panel, entry, prev)
	end
end


hook.Add("PopulateToolMenu", "Addon Share menu", function ()
	spawnmenu.AddToolMenuOption("Utilities", "Addon Share", "Addon_Share", "Addons", "", "", addonMenu)
end)
