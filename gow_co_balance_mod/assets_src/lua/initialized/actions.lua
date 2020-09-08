local Events = require "initialized/events"
local Wargroove = require "wargroove/wargroove"

local inspect = require "inspect"

local Actions = {}

function Actions.init()
  Events.addToActionsList(Actions)
end

function Actions.populate(dst)
    dst["overheal_state_update"] = Actions.overhealStateUpdate
    -- dst["aw_fire_vision"] = Actions.awFireVision
end

function Actions.overhealStateUpdate(context)
    print('==Actions.overhealStateUpdate')
    print(inspect(context))
    local playerId = context:getPlayerId(0) -- TODO: do for both players
    
    local allUnits = Wargroove.getAllUnitsForPlayer(playerId, true)
    for i, u in ipairs(allUnits) do
        local overhealState = Wargroove.getUnitState(u, "overheal")
        print("overhealstate", overhealState)
        print("health", u.health)
        -- if (overhealState ~= nil and u.health <= 100) then
        if (u.health <= 100) then
            print('= hp set to 0')
            Wargroove.setUnitState(u, "overheal", 0)
            -- print(inspect(unit))
            Wargroove.updateUnit(u)
        end
    end

    -- local playerId = Wargroove.getCurrentPlayerId()
    -- local units = Wargroove.getUnitsAtLocation(nil)
    -- if hp > 100 then
    --     print('= overheal set')
    --     Wargroove.setUnitState(unit, "overheal", hp)
    -- else
    --     print('= hp set to nil')
    --     Wargroove.setUnitState(unit, "overheal", nil)
    -- end
    -- print(inspect(unit))
    -- Wargroove.updateUnit(unit)
    
end

-- function Actions.awFireVision(context)

--     local playerId = Wargroove.getCurrentPlayerId()
--     local units = Wargroove.getUnitsAtLocation(nil)
--     for i, unit in ipairs(units) do
--         if unit.unitClass.id == "aw_fire" then
--             unit.playerId = playerId
--             Wargroove.updateUnit(unit)
--         end
--     end
--     Wargroove.updateFogOfWar(nil)
    
-- end

-- function Actions.spawnFire(context)

--     local playerId = 0
--     for i, unit in ipairs(Wargroove.getUnitsAtLocation(nil)) do
--         if unit.unitClass.id == "villager" then
--             local pos = unit.pos
--             Wargroove.removeUnit(unit.id)
--             Wargroove.waitFrame()
--             if Wargroove.canStandAt("aw_fire", pos) then
--                 Wargroove.spawnUnit(playerId, pos, "aw_fire", false)
--                 Wargroove.waitFrame()
--             end
--         end
--     end
--     Wargroove.updateFogOfWar(nil)
-- end

return Actions