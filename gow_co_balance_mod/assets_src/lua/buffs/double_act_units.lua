local TempUnits = require "temp_units"

local DoubleActUnits = {}

-- using .forward since the value is what gets used to assign the buffs, not the key
DoubleActUnits["unitClasses"] = TempUnits.forward; 

function DoubleActUnits.createFunction(buffedUnitClass)
    function tempFunction(Wargroove, unit)
        if Wargroove.isSimulating() then
            return
        end
    
        if unit.playerId ~= Wargroove.getCurrentPlayerId() then
            unit.unitClassId = TempUnits.reverse[buffedUnitClass]
            unit.grooveCharge = 0
            Wargroove.updateUnit(unit)
        end
    end

    return tempFunction
end

return DoubleActUnits
