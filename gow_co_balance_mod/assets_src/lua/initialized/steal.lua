local Wargroove = require "wargroove/wargroove"
local Verb = require "wargroove/verb"
local OldSteal = require "verbs/steal"

local Steal = Verb:new()

local stateKey = "gold"

function Steal:init()
    OldSteal.canExecuteWithTarget = Steal.canExecuteWithTarget
    OldSteal.execute = Steal.execute
end

function Steal:canExecuteWithTarget(unit, endPos, targetPos, strParam)
    local targetUnit = Wargroove.getUnitAt(targetPos)
    return targetUnit and (targetUnit.unitClass.isStructure or targetUnit.unitClass.loadCapacity > 0) and Wargroove.areEnemies(unit.playerId, targetUnit.playerId) and targetUnit.playerId >= 0 and self:canExecuteWithTargetId(targetUnit.unitClassId)
end

function Steal:execute(unit, targetPos, strParam, path)
    local targetUnit = Wargroove.getUnitAt(targetPos)
    local amountToTake = self:getAmountToSteal()

    Wargroove.playMapSound("thiefSteal", targetPos)
    Wargroove.waitTime(0.2)
    Wargroove.spawnMapAnimation(targetPos, 0, "fx/ransack_1", "default", "over_units", { x = 12, y = 0 })
    Wargroove.waitTime(0.8)
    Wargroove.spawnMapAnimation(unit.pos, 0, "fx/ransack_2", "default", "over_units", { x = 12, y = 0 })
    Wargroove.waitTime(0.3)
    Wargroove.playMapSound("thiefGoldObtained", targetPos)
    Wargroove.waitTime(0.3)

    if targetUnit.unitClass.isStructure then
        Wargroove.setUnitState(unit, stateKey, amountToTake)
        unit.unitClassId = "thief_with_gold"
        Wargroove.changeMoney(targetUnit.playerId, -amountToTake)
    else
        targetUnit.playerId = unit.playerId
        unit:setHealth(0, targetUnit.id)
        Wargroove.updateUnit(targetUnit)
        Wargroove.updateUnit(unit)
    end

    if (targetUnit.unitClassId ~= "hq" and targetUnit.unitClass.isStructure) then
        targetUnit:setHealth(0, unit.id)
        Wargroove.updateUnit(targetUnit)
    end

    Wargroove.waitTime(0.5)
end

return Steal