local OldWargroove = require "wargroove/wargroove"

local Wargroove = {}

local api = wargrooveAPI
wargrooveAPI = nil

local helpers = require "helpers"
local inspect = require "inspect"

local CopyWargroove = helpers.deepcopy(OldWargroove)

function Wargroove:init()
    print('===Wargroove.init')
    OldWargroove.syncedClient = false
    for k,v in pairs(Wargroove) do
        if (k ~= 'debugWrap') and (type(v) == 'function') then
            print(k)
            OldWargroove[k] = helpers.debugWrap(v)
        end
    end
end

function Wargroove.updateUnit(unit)
    print('===Wargroove.updateUnit')
    -- set overhealing in state
    local hp = unit.health -- conversion may be unnecessary with below

    if type(hp) == "string" then
        print('hpstring', hp)
        if hp == "" then
            unit.health = OldWargroove.getUnitState(unit, "overheal")
            print(inspect(unit))
            CopyWargroove.updateUnit(unit)
            return
        end
    end

    -- local hp = tonumber(unit.health) -- conversion may be unnecessary with below
    if hp > 100 then
        OldWargroove.setUnitState(unit, "overheal", hp)
    else
        OldWargroove.setUnitState(unit, "overheal", nil)
    end
    print('in update')
    print('hp:  ', hp)

    print(inspect(unit))
    CopyWargroove.updateUnit(unit)
end

function Wargroove.syncClient(allUnitIds)
    print('===Wargroove.syncClient')
    print('allunits', inspect(allUnitIds))
    for i, id in ipairs(allUnitIds) do
        print(id)
        local unit = OldWargroove.getUnitById(id)
        print(inspect(unit))
        local overhealState = OldWargroove.getUnitState(unit, "overheal")
        print("overhealState", overhealState)
        if (overhealState ~= nil and overhealState ~= "" and overhealState ~= "0") then
            if tonumber(overhealState) then
                unit.health = tonumber(overhealState)
            else
                unit.health = overhealState
            end
            print('in syncClient')
            print(inspect(unit))
            OldWargroove.updateUnit(unit)
        end
        
    end
    
end

-- sync on initial load, rejoin suspended game
function Wargroove.getAllUnitIds()
    print('===Wargroove.getAllUnitIds')
    print('synced?', OldWargroove.syncedClient)
    local allUnitIds = CopyWargroove.getAllUnitIds()
    print('allunitids', inspect(allUnitIds))
    if (helpers.tableLength(allUnitIds) > 0 and OldWargroove.syncedClient == false) then
        OldWargroove.syncedClient = true
        OldWargroove.syncClient(allUnitIds)
    end    

    return allUnitIds
end

function Wargroove.getUnitById(unitId)
    assert(unitId ~= nil)

    local result = CopyWargroove.getUnitById(unitId)
    if result == nil then
        return nil
    end

    -- allow overhealing in some instances
    local function unitSetHealth(self, health, attackerId, source)
        local maxHp = 100
        if source == "mercia_groove" then
            maxHp = 105
        end
        if source == "dm_groove" and self.unitClassId == "commander_darkmercia" then
            maxHp = 200
        end
        self.health = math.floor(math.max(0, math.min(health, maxHp)) * 0.01 * self.unitClass.maxHealth + 0.5)
        self.attackerId = attackerId
        if attackerId >= 0 then
            attacker = CopyWargroove.getUnitById(attackerId)
            self.attackerUnitClass = attacker.unitClass.id
            self.attackerPlayerId = attacker.playerId
        end
    end

    if unitId == -1 then
        return nil
    end
    
    result.setHealth = unitSetHealth

    return result
end

return Wargroove