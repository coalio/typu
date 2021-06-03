local event_master = {}

event_master['RANGELINE'] = function(action)
    local event = Event:new {
        action = "move",
        attribution_id = 2,
        event_type = "Entity",
        payload = {
            --[[ x ]] action.params[1], --[[ y ]] 0
        }
    }
    
    manager.events_stack:push(event)
end

event_master['SET_SPEED'] = function(action)
    local event = Event:new {
        action = "set_speed",
        attribution_id = 0,
        event_type = "Game",
        payload = {
            --[[ speed ]] action.params[1]
        }
    }
    
    manager.events_stack:push(event)
end

return event_master