local game = {
    preview_font = love.graphics.newFont(12),
    current_font = love.graphics.newFont(24),
    keystroke_font = love.graphics.newFont(64),
    currently_playing = nil,
    entered_instruction = nil,
    video = nil,
    background = nil,
    map = nil,
    current = {
        instruction_index = nil,
        old_clock = 0,
        lyrics = nil,
        speed = 1000 -- test speed
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

    self.current.instruction_index = 1
    self.current.old_clock = love.timer.getTime()  * 1000
end

function game:generateLyrics()
    local text = self.current.instruction.text

    -- Generate text
    Text:new {
        text = text,
        font = self.keystroke_font,
        type = "dynamic_text",

        pos = {
            x = env.window.width,
            y = env.window.height / 2 - (48 / 2)
        },

        mov = {
            vx = self.current.speed,
            vy = 0
        },

        dim = {
            w = self.keystroke_font:getWidth(text),
            h = self.keystroke_font:getHeight()
        }
    }
end

function game:finish()
    -- game finished
    os.exit(0) -- eh, ill do something here eventually
end

function game:nextInstruction()
    self.current.old_clock = self.current.time
    self.current.instruction_index = self.current.instruction_index + 1
    self.entered_instruction = not self.entered_instruction

    if (not self.current.instruction or self.current.instruction.text and self.current.instruction.text:match('END')) then
        game:finish()
    end
end

function game:performAction(action)
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

function game:update()
    self.current.instruction = self.map[self.current.instruction_index]
    self.current.next_instruction = self.map[self.current.instruction_index + 1]
    
    if (not self.entered_instruction) then
        self.entered_instruction = not self.entered_instruction
        if (self.current.instruction.text) then
            self:generateLyrics()
        end
    end

    self.current.time = love.timer.getTime() * 1000
    if (self.current.time - self.current.old_clock < self.current.instruction.interval) then
        for _, action in pairs(self.current.instruction.actions) do
            self:performAction(action)
        end
    else
        self:nextInstruction(self.current.instruction, self.current.time)
    end

    -- Move text
    for index, keystroke in pairs(manager.entities:getKeystrokes()) do
        if (keystroke:isOutOfBounds()) then
            keystroke:destroy()
        else
            keystroke:move(-1, 0)
        end
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
    
    gradient.draw(self.background.gradient_bottom, 0, env.window.height - 100, env.window.width, 100)
    gradient.draw(self.background.gradient_top, 0, 0, env.window.width, 200)
    if (self.current.next_instruction and self.current.next_instruction.text) then
        -- text
        love.graphics.setFont(self.preview_font)
        love.graphics.print(
            self.current.next_instruction.text,
            10,
            env.window.height - 54
        )
    end

    if (self.current.instruction.text and self.current.instruction_index ~= 1) then
        love.graphics.setFont(self.current_font)
        love.graphics.print(
            self.current.instruction.text,
            10,
            env.window.height - 36
        )
    end

    -- dynamic text
    for index, keystroke in pairs(manager.entities:getKeystrokes()) do
        keystroke:draw()
    end
end

return game