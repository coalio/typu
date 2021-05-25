local game = {
    currently_playing = nil,
    video = nil,
    background = nil,
    map = nil,
    current = {
        instruction = nil,
        old_clock = 0
    }
}

function game:play(map_data)
    self.map = map_data
    for line, command in ipairs(map_data) do
        for _, action in pairs(command.actions) do
            if (action.type == "VIDEO") then
                local video_path = table.concat(action.params)
                self.background = Background:new {
                    video = Video:new {
                        _stream = love.graphics.newVideo(map_data.path .. video_path)
                    }
                }
            elseif (action.type == "SONG_NAME") then
                local name = table.concat(action.params)
                self.name = name
            end
        end
    end

    self.currently_playing = true
    if (self.background.video) then
        self.background.video:play()
    end

    self.current.instruction = 1
    self.current.old_clock = love.timer.getTime()  * 1000
end

function game:update()
    local current_time = love.timer.getTime() * 1000
    if (current_time - self.current.old_clock < self.map[self.current.instruction].interval) then
        for _, action in pairs(self.map[self.current.instruction].actions) do
            if (action.type == "RANGELINE") then
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
        end
    else
        self.current.old_clock = current_time
        self.current.instruction = self.current.instruction + 1
    end
end

function game:draw()
    if (not self.currently_playing) then return end

    -- Draw the background
    self.background:draw()

    -- Draw entities
    for id, entity in pairs(manager.entities:getDrawable()) do
        entity:draw()
    end

    -- Finally draw the UI
    gradient.draw(self.background.gradient, 0, env.window.height - 200, env.window.width, 200)
end

return game