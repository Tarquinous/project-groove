local Events = require "wargroove/events"
local Wargroove = require "wargroove/wargroove"

local Triggers = {}

function Triggers.getOverhealTrigger(referenceTrigger)
    local trigger = {}
    trigger.id =  "overhealStateRemoval"
    trigger.recurring = "repeat"
    trigger.players = referenceTrigger.players
    trigger.conditions = {}
    trigger.actions = {}
    
    table.insert(trigger.conditions, { id = "player_turn", parameters = { "current" } })
    table.insert(trigger.conditions, { id = "end_of_unit_turn", parameters = { } })
    table.insert(trigger.actions, { id = "overheal_state_update", parameters = { "current" }  })
    
    return trigger
end

return Triggers