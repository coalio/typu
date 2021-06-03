local game = {
    preview_font = love.graphics.newFont(12),
    current_font = love.graphics.newFont(24),
    keystroke_font = love.graphics.newFont(64),
    preview_keystroke_font = love.graphics.newFont(48),
    currently_playing = nil,
    entered_instruction = nil,
    video = nil,
    background = nil,
    map = nil,
    current = {
        keystrokes = '',
        keystrokes_offset = 0,
        instruction_index = nil,
        old_clock = 0,
        speed = 500, -- Test speed, this should be set from the map
        sentence = {} -- This is the sub in range
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
        type = "lyric_dynamic",

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

function game:updateKeystrokesPreview()
    local last_keystroke = {}
    for index, keystroke in pairs(manager.entities:getKeystrokes()) do
        if (keystroke:isInRange()) then
            last_keystroke = keystroke
            break
        end
    end

    if (not last_keystroke.pos) then
        game.current.keystrokes = ''
        return
    end

    game.current.keystrokes = last_keystroke.text
    return
end

function game:handleKeypress(key, scancode, is_repeat)
    local sentences = self:checkInRange()

    table.sort(sentences, function(a, b)
        return a.keystroke.pos.x < b.keystroke.pos.x 
    end)

    -- The closest sentence takes relevancy
    local sentence = sentences[1]
    if (not sentence) then
        return -- No sentences in range
    end

    if (key == sentence.string:sub(1, 1)) then
        local text = 
            sentence.keystroke.text:sub(1, (sentence.sub_off.at or 0)) ..
            sentence.keystroke.text:sub((sentence.sub_off.at or 0) + 2, -1)

        sentence.keystroke.text = text
        sentence.keystroke.pos.x = sentence.keystroke.pos.x + sentence.keystroke.sub[1].width

        if (sentence.keystroke.text:len() == 0) then
            sentence.keystroke:destroy()
            return
        end

        sentence.keystroke:updateSubs(sentence.sub_off.at)
    end
end

function game:nextInstruction()
    self.current.old_clock = self.current.time
    self.current.instruction_index = self.current.instruction_index + 1
    self.entered_instruction = not self.entered_instruction

    if (not self.current.instruction or self.current.instruction.text and self.current.instruction.text:match('END')) then
        self:finish()
    end
end

function game:performAction(action)
    local handler = event_master[action.type]
    if (handler) then
        handler(action)
    end
end

function game:checkInRange()
    local sentences_in_range = {}
    for id, keystroke in pairs(manager.entities:getKeystrokes()) do
        if (keystroke:isInRange()) then
            local sub_in_range = keystroke:getSubInRange()
            local sub_off_range = keystroke:getSubOffRange()
            if (sub_in_range.string) then
                table.insert(
                    sentences_in_range,
                    {
                        keystroke = keystroke,
                        sub_in = sub_in_range,
                        sub_off = sub_off_range,
                        string = sub_in_range.string:sub(sub_off_range.at or 1, -1)
                    }
                )
            end
        end
    end

    self.current.sentences = sentences_in_range
    return self.current.sentences
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

    game:updateKeystrokesPreview()
end

function game:drawKeystrokes()
    for index, keystroke in pairs(manager.entities:getKeystrokes()) do
        keystroke:draw()
    end
end

function game:draw()
    if (not self.currently_playing) then return end

    self.background:draw()

    for id, entity in pairs(manager.entities:getDrawable()) do
        entity:draw()
    end

    interface.drawGradients() -- Background gradients
    interface.drawLyricsPreview()
    
    game:drawKeystrokes()
end

function game:eventHandler(event)
    if (event.action == "set_speed") then
        game.current.speed = event.payload[1]
    end
end

return game