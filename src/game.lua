--[[
    game.lua
    
    This file contains all the methods required to play a map. It is not in charge
    of anything else than the gameplay.
]]

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
        turn = 0,
        instruction_index = nil,
        keystrokes = '',
        keystrokes_offset = 0,
        last_key = '',
        old_clock = 0,
        sentence = {}, -- This is the sub in range
        speed = 500 -- Test speed, this should be set from the map
    }
}

--[[
    This function starts the game
    
    It receives map_data, which is the deserialized contents of the map
    It sets self.map to map_data for reading
    It assigns map_data[1] to a variable called about, and iterates through it. "about" only refers
    to the map metadata, such as the video, name, author, etc...
    
    Finally, sets "currently_playing" to true and plays the video
]]
function game:play(map_data)
    self.map = map_data
    local about = map_data[1]
    for _, action in pairs(about.actions) do
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

    self.currently_playing = true
    if (self.background.video) then
        self.background.video:play()
    end

    self.current.instruction_index = 1
    self.current.old_clock = love.timer.getTime()  * 1000
end

--[[
    This function generates the keystrokes for the user to type
    It creates a new instance of the "Keystrokes" class, which derives from "Entity" class.
]]
function game:keystrokes()
    local text = self.current.instruction.text

    -- Generate text
    Keystrokes:new {
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

--[[
    This function runs when the game is over
    Its supposed to display the overall results of the match, but right now it does nothing.
]]
function game:finish()
    os.exit(0)
end 

--[[
    Update the keystrokes preview (the preview text in the middle)
]]
function game:updateKeystrokesPreview()
    local preview_keystroke = self:getCurrentKeystroke()
    game.current.keystrokes = preview_keystroke and preview_keystroke.keystroke.text or ''
    return
end


--[[
    This function returns you the current keystrokes group.

    It uses memoization because it might be called more than once in the same turn.
]]
function game:getCurrentKeystroke()
    if (memoization:isMemoized('getCurrentKeystroke', self.current.turn)) then
        local memoized = memoization['getCurrentKeystroke'][self.current.turn]
        return memoized.string:len() < 1 and nil or memoized
    end

    local sentences = self:checkInRange()
    table.sort(sentences, function(a, b)
        return a.keystroke.pos.x < b.keystroke.pos.x 
    end)

    -- The closest sentence takes relevancy
    local sentence = sentences[1]
    memoization:memoize('getCurrentKeystroke', self.current.turn, sentence or {string = ''})

    if (not sentence) then
        return nil -- No sentences in range
    end

    return sentence
end

--[[
    This function is in charge of handling the pressed keys.
    
    It does not filter the keys pressed, it only checks if this key matches the keystroke,
    in which case it then counts the key, updates the keystroke and returns either true or false
    depending if the key was the correct one.
]]
function game:handleKeypress(key, scancode, is_repeat)
    local sentence = game:getCurrentKeystroke()
    if (not sentence) then
        return nil 
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
        self.current.last_key = key

        return true
    else
        return false
    end
end

--[[
    This function checks if the current key is repeated and the keystrokes group require the user to
    hold (repeat) this key, in which case then it would be valid to repeat the same keystroke.
]]
function game:isKeystrokeRepeated(key)
    local sentence = game:getCurrentKeystroke()

    if (not sentence) then
        return false
    end

    if (self.current.last_key == key and key == sentence.string:sub(1, 1)) then
        return true
    end

    return false
end

--[[
    This function runs when the current instruction is done, in which case jumps to the next instruction.

    It also checks if the game is finished.
]]
function game:nextInstruction()
    self.current.old_clock = self.current.time
    self.current.instruction_index = self.current.instruction_index + 1
    self.entered_instruction = not self.entered_instruction

    if (not self.current.instruction or self.current.instruction.text and self.current.instruction.text:match('END')) then
        self:finish()
    end
end

--[[
    This function gets the handler for this action type and runs it (if any).
]]
function game:performAction(action)
    local handler = event_master[action.type]
    if (handler) then
        handler(action)
    end
end

--[[
    This functino returns you a list of the keystrokes in range (between borderline and rangeline).

    It uses memoization for the results because, in the same turn, the same sentences will be in range as
    none has moved anywhere.
]]
function game:checkInRange()
    if (memoization:isMemoized('checkInRange', self.current.turn)) then
        return memoization['checkInRange'][self.current.turn]
    end

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
    memoization:memoize('checkInRange', self.current.turn, sentences_in_range)
    return self.current.sentences
end

--[[
    This is the game update function.

    It checks for the keystrokes, calls every other method and runs every action for the instruction.
    Its in charge of managing the intervals, the generation of keystrokes, etc...

    It constantly moves the keystrokes.
]]
function game:update()
    self.current.turn = self.current.turn + 1
    self.current.instruction = self.map[self.current.instruction_index]
    self.current.next_instruction = self.map[self.current.instruction_index + 1]
    
    if (not self.entered_instruction) then
        self.entered_instruction = not self.entered_instruction
        if (self.current.instruction.text) then
            self:keystrokes()
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

    self:updateKeystrokesPreview()

    local key_array = keyboard:getKeyboardStateArray()
    for index, keystroke in ipairs(key_array) do
        if index == env.key_limit then break end
        if (not keyboard:isKeystrokeValidated(keystroke.index) and not self:isKeystrokeRepeated(keystroke.key)) then
            local is_keystroke_correct = self:handleKeypress(keystroke.key)
            if (not is_keystroke_correct) then 
                keyboard:validateKeystroke(keystroke)
                break
            else
                keyboard:validateKeystroke(keystroke)
            end
        end
        --[[ Continue loop for every valid keystroke ]]
    end
end

--[[
    This function draws the keystrokes
]]
function game:drawKeystrokes()
    for index, keystroke in pairs(manager.entities:getKeystrokes()) do
        keystroke:draw()
    end
end

--[[
    This function draws the game scene, in this order:

    - Background
    - Higher priority entities
    - Top-bottom gradients (background, these ones are drew appart because they have to be in top of the entities)
    - Lyrics previews
    - Keystrokes
]]
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

--[[
    This function is in charge of handling the "Game" type events (those that affect the factors of the game)
]]
function game:eventHandler(event)
    if (event.action == "set_speed") then
        game.current.speed = event.payload[1]
    end
end

return game