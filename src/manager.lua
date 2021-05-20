local manager = {}

local function manager:eventHandler() {
    while (not events_stack:isEmpty) do
        local event = events_stack:pop()
        if (event.event_type == 1) then
            -- actor type event
            self.actors[event.attribution_id]:eventHandler(event)
        end
    end
}

local events_stack = {}

local function events_stack:push(event)
    self.event_list[#self.event_list + 1] = event
end

local function events_stack:pop()
    return table.remove(self.event_list, #self.event_list)
end

local function events_stack:isEmpty()
    return #self.event_list == 0
end

return {
    actors = {},
    events_stack = events_stack
}