-- output handler
local function printLine(message)
	if message then
		DEFAULT_CHAT_FRAME:AddMessage("|cffff8000DankScore:|r " .. message);
	end
end


-- bullshit compatability function because GetItemInfo doesn't work with links in 1.12
local function getItemIdFromLink(link)
	local cutFront = string.sub(link, 18);
	local last = string.find(cutFront, ":");
	local finalString = string.sub(cutFront, 0, last-1);
	return finalString;
end


-- compute gearscore
local function getGearScore(player, target)
	local name, gearscore, success = "", 0, false;

	-- Sort out targets
	if UnitExists(target) then
		if UnitName(player) == UnitName(target) then
			name = "yourself";
			target = player;
		else
			name = UnitName(target);
		end
	else
		name = "yourself";
		target = player;
	end

	-- Check if target is a player
	if UnitIsPlayer(target) then
		success = true;
	end

	-- Iterate through all equipped items and assign a gearscore
	for i=1, 18 do
		local itemLink = GetInventoryItemLink(target, i);
		if not (itemLink == nil) then
			local itemId = getItemIdFromLink(itemLink);
			local _, _, _, itemLevel = GetItemInfo(itemId);
			gearscore = gearscore + itemLevel;
		end
	end

	return name, gearscore, success;
end


-- slash command handler
SLASH_DANKSCORE1 = "/dankscore";
local function slashCommand(msg, editbox)
	local name, gearscore, success = getGearScore("player", "target");
	if success then
		printLine("The DankScore for " .. name .. " is '" .. gearscore .. "'");
	else
		printLine(name .. " is not a player.");
	end
end
SlashCmdList["DANKSCORE"] = slashCommand;
