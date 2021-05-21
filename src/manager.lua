local manager = {}

function manager:eventHandler() 
    while (not events_stack:isEmpty()) do
        local event = events_stack:pop()
        if (event.event_type == 1) then
            -- actor type event
            self.actors[event.attribution_id]:eventHandler(event)
        end
    end
end

local actors_list = {}

function actors_list:add(actor)
    self[actor.id] = actor
end

function actors_list:delete(id)
    table.remove(self, id)
end

function actors_list:getDrawable()
    local drawable_actors = {}

    for id, actor in pairs(self) do
        if (type(actor) ~= "function") --[[ ignore prototype ]] then
            if (actor:isVisible()) then
                table.insert(drawable_actors, actor)
            end
        end
    end

    return drawable_actors
end

local events_stack = {}

function events_stack:push(event)
    self.event_list[#self.event_list + 1] = event
end

function events_stack:pop()
    return table.remove(self.event_list, #self.event_list)
end

function events_stack:isEmpty()
    return #self.event_list == 0
end

manager.actors_list = actors_list
manager.events_stack = events_stack

return manager