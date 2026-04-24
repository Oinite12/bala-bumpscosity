-- Talisman incompat
-- for the funy xd
if (
	(SMODS.Mods["Talisman"] or {}).can_load
	and not (SMODS.Mods["Amulet"] or {}).can_load
) then
	error([[TALISMAN detected!




====== HOW TO FIX THIS CRASH ======
1. Uninstall Talisman
2. Install Amulet
https://github.com/frostice482/amulet



]])
end

local bumps_mod_obj = SMODS.current_mod --[[@as table]]
local bumps_cfg = bumps_mod_obj.config
local bumps_low = 10
local bumps_high = 90

-- Add Bumpscosity slider
local uid_settings_ref = G.UIDEF.settings_tab
function G.UIDEF.settings_tab(tab)
    local uidef = uid_settings_ref(tab)
    if tab ~= 'Game' then return uidef end

    table.insert(uidef.nodes, 3, create_slider({
        label = localize('b_bumps_bumpscosity'),
        w = 4, h = 0.4,
        ref_table = bumps_cfg,
        ref_value = "bumpscosity",
        min = 0, max = 100
    }))

    return uidef
end

-- Force bumpscosity quips
local smods_quip_ref = SMODS.quip
function SMODS.quip(quip_type)
    local bumps = bumps_cfg.bumpscosity
    local bumps_is_low  = bumps <= bumps_low
    local bumps_is_high = bumps_high <= bumps

    if not (bumps_is_low or bumps_is_high) then
        return smods_quip_ref(quip_type)
    end

    local key = 'bumps_jimbo_%s_%s_bumps'
    local type = quip_type
    local amount = (bumps_is_low and 'low') or (bumps_is_high and 'high')

    return key:format(type, amount), {}
end

-- Add quips
local ret_false = function(self, quip_type) return false end
for _,type in ipairs({'loss', 'win'}) do
    for _,amount in ipairs({'low', 'high'}) do
        SMODS.JimboQuip {
            key = ('jimbo_%s_%s_bumps'):format(type, amount),
            type = type, filter = ret_false
        }
    end
end

-- Mod icon
SMODS.Atlas { key = 'modicon',
    path = 'modicon.png',
    px = 34, py = 34
}