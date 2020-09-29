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

function Triggers.getManaInit(referenceTrigger)
    local trigger = {}
    trigger.id =  "manaInit"
    trigger.recurring = "once"
    trigger.players = {1,0,0,0,0,0,0,0}
    trigger.conditions = {}
    trigger.actions = {}

    table.insert(trigger.conditions, { id = "player_turn", parameters = { "current" } })
    table.insert(trigger.conditions, { id = "start_of_turn", parameters = { } })
    table.insert(trigger.actions, { id = "mana_init", parameters = { "current" }  })

    return trigger
end

function Triggers.getManaCount(referenceTrigger)
    local trigger = {}
    trigger.id =  "manaCount"
    trigger.recurring = "repeat"
    trigger.players = referenceTrigger.players
    trigger.conditions = {}
    trigger.actions = {}

    table.insert(trigger.conditions, { id = "player_turn", parameters = { "current" } })
    table.insert(trigger.conditions, { id = "start_of_turn", parameters = { } })
    table.insert(trigger.actions, { id = "mana_count", parameters = { "current" }  })

    return trigger
end

return Triggers