local manager = {}

function manager:eventHandler() 
    while (not self.events_stack:isEmpty()) do
        local event = self.events_stack:pop()
        if (event.event_type == "Entity") then
            self.entities[event.attribution_id]:eventHandler(event)
        end
    end
end

local entities = {}

function entities:add(entity)
    self[entity.id or #self.entities + 1] = entity
end

function entities:delete(id)
    table.remove(self, id)
end

function entities:getDrawable()
    local drawable_entities = {}

    for id, entity in pairs(self) do
        if (type(entity) ~= "function") --[[ ignore prototype ]] then
            if (entity:isVisible()) then
                table.insert(drawable_entities, entity)
            end
        end
    end

    return drawable_entities
end

local events_stack = {
    _events = {}
}

function events_stack:push(event)
    self._events[#self._events + 1] = event
end

function events_stack:pop()
    return table.remove(self._events, #self._events)
end

function events_stack:isEmpty()
    return #self._events == 0
end

local fonts = {}

function fonts:add(font)
    self[font.id] = font
end

function fonts:delete(id)
    table.remove(self, id)
end

manager.entities = entities
manager.events_stack = events_stack
manager.fonts = fonts

return manager