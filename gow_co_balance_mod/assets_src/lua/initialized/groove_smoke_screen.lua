local Wargroove = require "wargroove/wargroove"
local GrooveVerb = require "wargroove/groove_verb"

local OldSmokeScreen = require "verbs/groove_smoke_screen"

local SmokeScreen = GrooveVerb:new()


function SmokeScreen:init()
    OldSmokeScreen.canExecuteWithTarget = SmokeScreen.canExecuteWithTarget
    OldSmokeScreen.execute = SmokeScreen.execute
    OldSmokeScreen.onPostUpdateUnit = SmokeScreen.onPostUpdateUnit
end

function SmokeScreen:canExecuteWithTarget(unit, endPos, targetPos, strParam)
    if not self:canSeeTarget(targetPos) then
        return false
    end

    local u = Wargroove.getUnitAt(targetPos)

    if u ~= nil then
        return false
    end

    if u == nil then
        return Wargroove.canStandAt("soldier", targetPos)
    end

    return true
end

function SmokeScreen:execute(unit, targetPos, strParam, path)
    Wargroove.setIsUsingGroove(unit.id, true)
    Wargroove.updateUnit(unit)
    
    Wargroove.playPositionlessSound("battleStart")
    Wargroove.playGrooveCutscene(unit.id)

    Wargroove.playUnitAnimation(unit.id, "groove")
    Wargroove.playMapSound("vesper/vesperGroove", unit.pos)
    Wargroove.waitTime(1.0)
    Wargroove.playMapSound("cutscene/smokeBomb", targetPos)
    Wargroove.spawnMapAnimation(targetPos, 3, "fx/groove/vesper_groove_fx", "idle", "over_units", {x = 12, y = 12})

    Wargroove.playGrooveEffect()

    local startingState = {}
    local pos = {key = "pos", value = "" .. targetPos.x .. "," .. targetPos.y}
    table.insert(startingState, pos)
    Wargroove.spawnUnit(unit.playerId, {x = -100, y = -100}, "smoke_producer", false, "", startingState)
    
    unit.pos = { x = targetPos.x, y = targetPos.y }

    Wargroove.updateUnit(unit)
    -- TODO: disappear in smoke, reappear after smoke cloud is made

    Wargroove.waitTime(1.0)
end

function SmokeScreen:onPostUpdateUnit(unit, targetPos, strParam, path)
    GrooveVerb.onPostUpdateUnit(self, unit, targetPos, strParam, path)
    unit.pos = targetPos
end

return SmokeScreen
