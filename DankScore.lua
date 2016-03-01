local DebugEnabled = false;

-- output handler
local function printLine(message)
  if message then
    DEFAULT_CHAT_FRAME:AddMessage("|cffff8000DankScore:|r " .. message);
  end
end

-- debug handler
local function debug(message)
  if DebugEnabled then
    DEFAULT_CHAT_FRAME:AddMessage("|cffff8000DankScore Debug:|r " .. message);
  end
end


-- bullshit compatability function because GetItemInfo doesn't work with links in 1.12
-- local function getItemIdFromLink(link)
--   local cutFront = string.sub(link, 18);
--   local last = string.find(cutFront, ":");
--   local finalString = string.sub(cutFront, 0, last-1);
--   return finalString;
-- end


-- weighting function
-- using http://wowwiki.wikia.com/wiki/Item_level#Stat_modifiers for stat weighting
-- scratch that, we're eyeballing the entire thing
local function weight(stat, value)
  local modified = 0;

  if     stat == "STR"               then modified = value;        -- strength
  elseif stat == "AGI"               then modified = value;        -- agility
  elseif stat == "STA"               then modified = value;        -- stamina
  elseif stat == "INT"               then modified = value;        -- intellect
  elseif stat == "SPI"               then modified = value;        -- spirit
  elseif stat == "ARMOR"             then modifier = value / 50;   -- reinforced armor (not base armor)

  elseif stat == "ARCANERES"         then                          -- arcane resistance
  elseif stat == "FIRERES"           then                          -- fire resistance
  elseif stat == "NATURERES"         then                          -- nature resistance
  elseif stat == "FROSTRES"          then                          -- frost resistance
  elseif stat == "SHADOWRES"         then                          -- shadow resistance

  elseif stat == "FISHING"           then                          -- fishing skill
  elseif stat == "MINING"            then                          -- mining skill
  elseif stat == "HERBALISM"         then                          -- herbalism skill
  elseif stat == "SKINNING"          then                          -- skinning skill
  elseif stat == "DEFENSE"           then modified = value * 4;    -- defense skill

  elseif stat == "BLOCK"             then modified = value * 14;   -- chance to block
  elseif stat == "BLOCKVALUE"        then modified = value * 0.5;  -- increased block value
  elseif stat == "DODGE"             then modified = value * 18;   -- chance to dodge
  elseif stat == "PARRY"             then modified = value * 20;   -- chance to parry
  elseif stat == "ATTACKPOWER"       then modified = value * 0.75  -- attack power
  elseif stat == "ATTACKPOWERUNDEAD" then modified = value * 0.5;  -- attack power against undead
  elseif stat == "ATTACKPOWERFERAL"  then modified = value * 0.35; -- attack power in feral form

  elseif stat == "CRIT"              then modified = value * 13;   -- chance to get a critical strike
  elseif stat == "RANGEDATTACKPOWER" then modified = value * 0.65; -- ranged attack power
  elseif stat == "RANGEDCRIT"        then modified = value * 11;   -- chance to get a crit with ranged weapons
  elseif stat == "TOHIT"             then modified = value * 13;   -- chance to hit

  elseif stat == "DMG"               then modified = value * 0.66; -- spell damage
  elseif stat == "DMGUNDEAD"         then modified = value * 0.75; -- spell damage against undead

  elseif stat == "ARCANEDMG"         then modified = value * 0.75; -- arcane spell damage
  elseif stat == "FIREDMG"           then modified = value * 0.75; -- fire spell damage
  elseif stat == "FROSTDMG"          then modified = value * 0.75; -- frost spell damage
  elseif stat == "HOLYDMG"           then modified = value * 0.75; -- holy spell damage
  elseif stat == "NATUREDMG"         then modified = value * 0.75; -- nature spell damage
  elseif stat == "SHADOWDMG"         then modified = value * 0.75; -- shadow spell damage
  elseif stat == "SPELLCRIT"         then modified = value * 13;   -- chance to crit with spells
  elseif stat == "HEAL"              then modified = value * 0.33; -- healing
  elseif stat == "HOLYCRIT"          then modified = value * 13;   -- chance to crit with holy spells
  elseif stat == "SPELLTOHIT"        then modified = value * 13;   -- Chance to Hit with spells

  elseif stat == "SPELLPEN"          then                          -- amount of spell resist reduction

  elseif stat == "HEALTHREG"         then modified = value / 5;    -- health regeneration per 5 sec.
  elseif stat == "MANAREG"           then modified = value * 7;    -- mana regeneration per 5 sec.
  elseif stat == "HEALTH"            then modified = value / 10;   -- health points
  elseif stat == "MANA"              then modified = value / 10;   -- mana points
  end

  return modified;
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
    local link = GetInventoryItemLink(target, i);
    if not (link == nil) then
      local _, _, itemLink, itemId = string.find(link, "|c%x+|H(item:(%d+):%d+:%d+:%d+)|h%[.-%]|h|r");
      local bonuses = BonusScanner:ScanItem(itemLink);
      for i, bonus in BonusScanner.types do
        if bonuses[bonus] then
          local weighted = weight(bonus, bonuses[bonus]);
          debug("Adding a score for " .. bonus .. " for " .. link .. " for DankScore: " .. weighted);
          gearscore = gearscore + weighted;
        end
      end
    end
  end

  return name, gearscore, success;
end


-- slash command handler
SLASH_DANKSCORE1 = "/dankscore";
local function slashCommand(msg)
  if string.lower(msg) == "debug" then
    DebugEnabled = not DebugEnabled;
    printLine("Debug mode: " .. tostring(DebugEnabled));
  else
    local name, gearscore, success = getGearScore("player", "target");
    if success then
      printLine("The DankScore for " .. name .. " is: " .. gearscore);
    else
      printLine(name .. " is not a player.");
    end
  end
end
SlashCmdList["DANKSCORE"] = slashCommand;
