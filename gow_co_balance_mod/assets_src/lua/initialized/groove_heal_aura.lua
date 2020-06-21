local Wargroove = require "wargroove/wargroove"
local GrooveVerb = require "wargroove/groove_verb"
local OldHeal = require "verbs/groove_heal_aura"

local Heal = GrooveVerb:new()

function Heal:init()
    OldHeal.execute = Heal.execute
end

local maxHealAmount = 50

function Heal:execute(unit, targetPos, strParam, path)
    Wargroove.setIsUsingGroove(unit.id, true)
    Wargroove.updateUnit(unit)

    Wargroove.playPositionlessSound("battleStart")
    Wargroove.playGrooveCutscene(unit.id)

    local targets = Wargroove.getTargetsInRange(targetPos, 3, "unit")

    Wargroove.playUnitAnimation(unit.id, "groove")
    Wargroove.playMapSound("mercia/merciaGroove", targetPos)
    Wargroove.waitTime(2.1)
    Wargroove.spawnMapAnimation(targetPos, 3, "fx/groove/mercia_groove_fx", "idle", "behind_units", {x = 12, y = 12})

    Wargroove.playGrooveEffect()

    local function distFromTarget(a)
        return math.abs(a.x - targetPos.x) + math.abs(a.y - targetPos.y)
    end
    table.sort(targets, function(a, b) return distFromTarget(a) < distFromTarget(b) end)

    for i, pos in ipairs(targets) do
        local u = Wargroove.getUnitAt(pos)
        local uc = u.unitClass
        if u ~= nil and Wargroove.areAllies(u.playerId, unit.playerId) and (not uc.isStructure) then
            u:setHealth(u.health + maxHealAmount, unit.id, "mercia_groove")
            Wargroove.updateUnit(u)
            Wargroove.spawnMapAnimation(pos, 0, "fx/heal_unit")
            Wargroove.playMapSound("unitHealed", pos)
            Wargroove.waitTime(0.2)
        end
    end
    Wargroove.waitTime(1.0)
end

return Heal
