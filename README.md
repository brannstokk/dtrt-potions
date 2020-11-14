# DTRT Potions

## Summary

Do The Right Thing with potions (and bandages) for World of Warcraft Classic.

## Description

When you are in a PVP instance DTRTPotions will attempt to use that
instance's PVP healing, mana, and bandage items if they are present in
your inventory.  It does this by dynamically rewriting three of your
macros: "Heal", "Mana", and "Bandage".  Using the the macros, by
clicking them or their keybinds, should just Do The Right Thing for
the zone you are in.

The macros are automatically updated whenever:

* Your inventory changes (e.g. an item is consumed, ItemRack moves
  things around in your bag, etc) (BAG_UPDATE)
* You change zones through a loading screen (PLAYER_ENTERING_WORLD)
* You exit combat (PLAYER_REGEN_ENABLED)

### Health restoration items

Healing item precedence table:

Normal | Alterac Valley | Arathi Basin | Warsong Gulch
------ | -------------- | ------------ | -------------
Major Healthstone | Major Healthstone | Major Healthstone | Major Healthstone
Major Healing Potion | Major Healing Draught | Major Healing Draught | Major Healing Draught
Combat Healing Potion | Combat Healing Potion | Combat Healing Potion | Combat Healing Potion
Superior Healing Potion | Major Healing Potion | Major Healing Potion | Major Healing Potion
Greater Healing Potion | Superior Healing Potion | Superior Healing Potion | Superior Healing Potion
Healing Potion | Greater Healing Potion | Greater Healing Potion | Greater Healing Potion
Lesser Healing Potion | Healing Potion | Healing Potion | Healing Potion
N/A | Lesser Healing Potion | Lesser Healing Potion | Lesser Healing Potion

### Mana restoration potions

In this case, we try to use PVP potions available before burning your
possibly-expensive non-PVP consumables.  Combat Mana Potions actually
heal for more than Superior, so if you have them, we prioritize them
in non-PVP zones as well.

Mana item precedence table:

Normal | Alterac Valley | Arathi Basin | Warsong Gulch
------ | -------------- | ------------ | -------------
Major Mana Potion | Combat Mana Potion | Combat Mana Potion | Combat Mana Potion
Combat Mana Potion | Major Mana Draught | Major Mana Draught | Major Mana Draught
Superior Mana Potion | Major Mana Potion | Major Mana Potion | Major Mana Potion
Greater Mana Potion | Superior Mana Potion | Superior Mana Potion | Superior Mana Potion
Mana Potion | Superior Mana Draught | Superior Mana Draught | Superior Mana Draught
Lesser Mana Potion | Greater Mana Potion | Greater Mana Potion | Greater Mana Potion
N/A | Mana Potion | Mana Potion | Mana Potion
N/A | Lesser Mana Potion | Lesser Mana Potion | Lesser Mana Potion

### Bandage items

Use the Battleground's bandage if available, otherwise fall back to
Heavy Runecloth.

Normal | Alterac Valley | Arathi Basin | Warsong Gulch
------ | -------------- | ------------ | -------------
Heavy Runecloth Bandage | Alterac Heavy Runecloth Bandage | Arathi Basin Runecloth Bandage | Warsong Gulch Runecloth Bandage
Runecloth Bandage | Heavy Runecloth Bandage | Highlander's Runecloth Bandage | Heavy Runecloth Bandage
Heavy Mageweave Bandage | Runecloth Bandage | Heavy Runecloth Bandage | Runecloth Bandage
Mageweave Bandage | Heavy Mageweave Bandage | Runecloth Bandage | Heavy Mageweave Bandage
Heavy Silk Bandage | Mageweave Bandage | Heavy Mageweave Bandage | Mageweave Bandage
Silk Bandage | Heavy Silk Bandage | Mageweave Bandage | Heavy Silk Bandage
Heavy Linen Bandage | Silk Bandage | Heavy Silk Bandage | Silk Bandage
Linen Bandage | Heavy Linen Bandage | Silk Bandage | Heavy Linen Bandage
N/A | Linen Bandage | Heavy Linen Bandage | Linen Bandage
N/A | N/A | Linen Bandage | N/A

## To-do

* Missing low-level battleground bandages
* Health Stone is listed in the addon and should be used first in the
  Heal macro, but I have not actually tested this
* Consider adding macros for secondary healing items (e.g. Whipper
  Root Tuber) and mana items (e.g. Demonic Rune)
* Consider adding macro for poison-cleansing items (e.g. Immature
  Venom Sac, Anti-Venom)
* Add an options UI:
  * Allow user to define their own item precendence lists without editing code
  * Allow user to change the names of the macros the addon uses without editing code

## Bugs

* The Heal and Mana macros are rewritten correctly when entering AV,
  AB and WSG, but the Bandage macro does not change until your first
  inventory update within the battleground.  For some reason
  GetInstanceInfo() returns "pvp" before GetZoneText() starts to
  return "Alterac Valley", "Warsong Gulch" or "Arathi Basin".

