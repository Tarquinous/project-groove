local FreeTurnUnits = {}

FreeTurnUnits["unitClasses"] = {
    "travelboat"
}

function FreeTurnUnits.createFunction(buffedUnitClass)
    function tempFunction(Wargroove, unit)
        if Wargroove.isSimulating() then
            return
        end
    
        if unit.playerId ~= Wargroove.getCurrentPlayerId() then
            if (Wargroove.getUnitState(unit, "freeTurnUsed") == "true") then
                Wargroove.setUnitState(unit, "freeTurnUsed", "false")
                Wargroove.updateUnit(unit)
            end
        end
    end

    return tempFunction
end

return FreeTurnUnits
