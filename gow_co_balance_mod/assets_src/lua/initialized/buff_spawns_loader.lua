-- local DoubleActUnits = require "buffs/double_act_units"

-- -- imported buffs should have a "unitClasses" field and a createFunction() field
local BuffSpawnsToLoad = {
--     DoubleActUnits,
}

-- loading game's original buffs first
local OldUnitBuffSpawns = require "wargroove/unit_buff_spawns"
local BaseGameBuffSpawns = require "buff_spawns/vanilla_unit_buff_spawns"


local BuffSpawnsLoader = {}
BuffSpawnsLoader.BuffSpawns = BaseGameBuffSpawns

function BuffSpawnsLoader:init()
    BuffSpawnsLoader.loadBuffSpawns()
    OldUnitBuffSpawns.BuffSpawns = BuffSpawnsLoader.BuffSpawns
    OldUnitBuffSpawns.getBuffSpawns = BuffSpawnsLoader.getBuffSpawns
end

local unpack = table.unpack or unpack

function stackFunctions(fcnOne, fcnTwo)
    print('wrapped BuffSpawns')
    return function (...)
        local arg = {...}
        arg.n = select("#", ...)
        fcnOne(unpack(arg, 1))  
        fcnTwo(unpack(arg, 1))  
    end
end


-- this function will apply any buffs we import and declare
function BuffSpawnsLoader.loadBuffSpawns()
    -- BuffSpawns["thief"] already exists, for example
    print('== BuffSpawnsLoader.load')

    for i, buffToLoad in pairs(BuffSpawnsToLoad) do
        print("buffSpawn#: ",i)
        for j, buffedUnit in pairs(buffToLoad.unitClasses) do
            print('buffSpawn loading: ', buffedUnit)
            local existingBuff = BuffSpawnsLoader.BuffSpawns[buffedUnit]
            if existingBuff == nil then
                BuffSpawnsLoader.BuffSpawns[buffedUnit] =  buffToLoad.createFunction(buffedUnit)
            else
                BuffSpawnsLoader.BuffSpawns[buffedUnit] = stackFunctions(existingBuff, buffToLoad.createFunction(buffedUnit))
            end
        end
    end
end

function BuffSpawnsLoader:getBuffSpawns()
    return BuffSpawnsLoader.BuffSpawns
end

return BuffSpawnsLoader