--[[
	Author: jlucas
	License: MIT License
]]

local PotFrame = CreateFrame("Frame")
PotFrame:RegisterEvent("BAG_UPDATE")
PotFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
PotFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
PotFrame:SetScript("OnEvent", function(...)

if InCombatLockdown() then return end

-- local healthstone = 19012 -- Major Healthstone
-- local normalPot = 13446 -- Major Healing Potion
-- local pvpPot = 18839 -- Combat Healing Potion
local name, type = GetInstanceInfo()
local macro = "#showtooltip\n/use "
local healingMacroName = "Heal"
local healingItemName = "";

local healthstone = 19012 -- Major Healthstone

local normalPots = {
   13446, -- Major Healing Potion (https://classic.wowhead.com/item=13446)
   18839, -- Combat Healing Potion (https://classic.wowhead.com/item=18839)
   3928,  -- Superior Healing Potion (https://classic.wowhead.com/item=3928)
}

local pvpPots = {
   17348, -- Major Healing Draught (https://classic.wowhead.com/item=17348)
   18839, -- Combat Healing Potion (https://classic.wowhead.com/item=18839)
   13446, -- Major Healing Potion (https://classic.wowhead.com/item=13446)
   3928,  -- Superior Healing Potion (https://classic.wowhead.com/item=3928)
}

-- print("Checking for "..healthstone)

if GetItemCount(healthstone) ~= 0 then
   healingItemName = select(1, GetItemInfo(healthstone)) -- use healthstone
elseif type == "pvp" then
   for idx, item in ipairs(pvpPots) do
      print("Checking for "..item)
      if GetItemCount(item) ~= 0 then
         print("Item count of "..item.." is"..GetItemCount(item))
         healingItemName = select(1, GetItemInfo(item)) -- use pvp pot
         break
      end
   end
else
   for idx, item in ipairs(normalPots) do
      if GetItemCount(item) ~= 0 then
         healingItemName = select(1, GetItemInfo(item)) -- use normal pot
         break
      end
   end
end

if manaItemName ~= "" then
   EditMacro(manaMacroName,manaMacroName,nil,macro..manaItemName)
   print("Macro "..manaMacroName.." is now using "..manaItemName)
else
   print("Macro "..manaMacroName.." was not modified: No healing items were found")
end

if healingItemName ~= "" then
   EditMacro(healingMacroName,healingMacroName,nil,macro..healingItemName)
   print("Macro "..healingMacroName.." is now using "..healingItemName)
else
   print("Macro "..healingMacroName.." was not modified: No healing items were found")
end

end)
