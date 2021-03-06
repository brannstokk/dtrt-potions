--[[
	Author: jlucas
	License: MIT License
]]

dtrtHealingItem = nil
dtrtManaItem = nil
dtrtBandageItem = nil

local PotFrame = CreateFrame("Frame")
PotFrame:RegisterEvent("BAG_UPDATE")
PotFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
PotFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
PotFrame:SetScript("OnEvent", function(...)

if InCombatLockdown() then return end

local name, type = GetInstanceInfo()
local zone = GetZoneText()
local macro = "#showtooltip\n/use "
local healingMacroName = "Heal"
local healingItemName = ""
local manaMacroName = "Mana"
local manaItemName= ""
local bandageMacroName = "Bandage"
local bandageItemName = ""

local alteracBandageId = 19307    -- AV vendor bandage
local highlanderBandageId = 20243 -- AB vendor bandage
local arathiBandageId = 20066     -- AB quest care package bandage
local wsgBandageId = 19066        -- WSG vendor bandage

-- Healing item lists

local healthstone = 19012 -- Major Healthstone

local normalHealthItems = {
   13446, -- Major Healing Potion (https://classic.wowhead.com/item=13446)
   18839, -- Combat Healing Potion (https://classic.wowhead.com/item=18839)
   3928,  -- Superior Healing Potion (https://classic.wowhead.com/item=3928)
   7181,  -- Greater Healing Potion (https://classic.wowhead.com/spell=7181)
   929,   -- Healing Potion (https://classic.wowhead.com/item=929/)
   858,   -- Lesser Healing Potion (https://classic.wowhead.com/item=858)
   118,   -- Minor Healing Potion (https://classic.wowhead.com/item=118)
}

local pvpHealthItems = {
   17348, -- Major Healing Draught (https://classic.wowhead.com/item=17348)
   18839, -- Combat Healing Potion (https://classic.wowhead.com/item=18839)
   13446, -- Major Healing Potion (https://classic.wowhead.com/item=13446)
   3928,  -- Superior Healing Potion (https://classic.wowhead.com/item=3928)
   17349, -- Superior Healing Draught (https://classic.wowhead.com/item=17349)
   7181,  -- Greater Healing Potion (https://classic.wowhead.com/spell=7181)
   929,   -- Healing Potion (https://classic.wowhead.com/item=929/)
   858,   -- Lesser Healing Potion (https://classic.wowhead.com/item=858)
}

-- Mana item lists

local normalManaItems = {
   13444, -- Major Mana Potion (https://classic.wowhead.com/item=13444)
   18841, -- Combat Mana Potion (https://classic.wowhead.com/item=18841)
   13443, -- Superior Mana Potion (https://classic.wowhead.com/item=13443)
   6149,  -- Greater Mana Potion (https://classic.wowhead.com/item=6149)
   3827,  -- Mana Potion (https://classic.wowhead.com/item=3827)
   3385,  -- Lesser Mana Potion (https://classic.wowhead.com/item=3385)
   2455,  -- Minor Mana Potion (https://classic.wowhead.com/item=2455)
}

local pvpManaItems = {
   18841, -- Combat Mana Potion (https://classic.wowhead.com/item=18841)
   17351, -- Major Mana Draught (https://classic.wowhead.com/item=17351)
   13444, -- Major Mana Potion (https://classic.wowhead.com/item=13444)
   13443, -- Superior Mana Potion (https://classic.wowhead.com/item=13443)
   17352, -- Superior Mana Draught (https://classic.wowhead.com/item=17352)
   6149,  -- Greater Mana Potion (https://classic.wowhead.com/item=6149)
   3827,  -- Mana Potion (https://classic.wowhead.com/item=3827)
   3385,  -- Lesser Mana Potion (https://classic.wowhead.com/item=3385)
}

local bandageItems = {
   14530, -- Heavy Runecloth Bandage (https://classic.wowhead.com/item=14530)
   14529, -- Runecloth Bandage (https://classic.wowhead.com/item=14529)
   8545,  -- Mageweave Bandage (https://classic.wowhead.com/item=8545)
   8544,  -- Mageweave Bandage (https://classic.wowhead.com/item=8544)
   6451,  -- Heavy Silk Bandage (https://classic.wowhead.com/item=6451)
   6450,  -- Silk Bandage (https://classic.wowhead.com/item=6450)
   3531,  -- Heavy Wool Bandage (https://classic.wowhead.com/item=3531)
   3530,  -- Wool Bandage (https://classic.wowhead.com/item=3530)
   2581,  -- Heavy Linen Bandage (https://classic.wowhead.com/item=2581)
   1251,  -- Linen Bandage (https://classic.wowhead.com/item=1251)
}

-- Set healing item

if GetItemCount(healthstone) > 0 then
   healingItemName = select(1, GetItemInfo(healthstone)) -- use healthstone
elseif type == "pvp" then
   for idx, item in ipairs(pvpHealthItems) do
      -- print("Checking for "..item)
      if GetItemCount(item) > 0 then
         -- print("Item count of "..item.." is"..GetItemCount(item))
         healingItemName = select(1, GetItemInfo(item)) -- use pvp pot
         break
      end
   end
else
   for idx, item in ipairs(normalHealthItems) do
      if GetItemCount(item) > 0 then
         healingItemName = select(1, GetItemInfo(item)) -- use normal pot
         break
      end
   end
end

-- Set mana potion item

if type == "pvp" then
   for idx, item in ipairs(pvpManaItems) do
      -- print("Checking for "..item)
      if GetItemCount(item) > 0 then
         -- print("Item count of "..item.." is"..GetItemCount(item))
         manaItemName = select(1, GetItemInfo(item)) -- use pvp pot
         break
      end
   end
else
   for idx, item in ipairs(normalManaItems) do
      if GetItemCount(item) > 0 then
         manaItemName = select(1, GetItemInfo(item)) -- use normal pot
         break
      end
   end
end

-- Set bandage item

if type == "pvp" then
   -- BUG For some reason, GetZoneText() still reports "Stormwind
   -- City" when first zoning into battlegrounds
   if zone == "Alterac Valley" and GetItemCount(alteracBandageId) > 0 then
      bandageItemName = select(1, GetItemInfo(alteracBandageId))
   elseif zone == "Arathi Basin" and GetItemCount(arathiBandageId) > 0 then
      bandageItemName = select(1, GetItemInfo(arathiBandageId))
   elseif zone == "Arathi Basin" and GetItemCount(highlanderBandageId) > 0 then
      bandageItemName = select(1, GetItemInfo(highlanderBandageId))
   elseif zone == "Warsong Gulch" and GetItemCount(wsgBandageId) > 0 then
      bandageItemName = select(1, GetItemInfo(wsgBandageId))
   -- XXX duplicate code
   else
      for idx, item in ipairs(bandageItems) do
         if GetItemCount(item) > 0 then
            bandageItemName = select(1, GetItemInfo(item))
         end
      end
   end
else
   -- XXX duplicate code
   for idx, item in ipairs(bandageItems) do
      if GetItemCount(item) > 0 then
         bandageItemName = select(1, GetItemInfo(item))
      end
   end
end

-- Build macros

if healingItemName ~= "" then
   EditMacro(healingMacroName,healingMacroName,nil,macro..healingItemName)
   if healingItemName ~= dtrtHealingItem then
      dtrtHealingItem = healingItemName
      print("Macro "..healingMacroName.." is now using "..healingItemName)
   end
end

if manaItemName ~= "" then
   EditMacro(manaMacroName,manaMacroName,nil,macro..manaItemName)
   if manaItemName ~= dtrtManaItem then
      dtrtManaItem = manaItemName
      print("Macro "..manaMacroName.." is now using "..manaItemName)
   end
end

if bandageItemName ~= "" then
      EditMacro(bandageMacroName,bandageMacroName,nil,macro..bandageItemName)
   if bandageItemName ~= dtrtBandageItem then
      dtrtBandageItem = bandageItemName
      print("Macro "..bandageMacroName.." is now using "..bandageItemName)
   end
end

end)
