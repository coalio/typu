local keyboard = {
    history = {},
    keyboard_state = {}, --[[ Behaves like SDL::GetKeyboardState ]]
    validated_keystrokes = {}
}

function keyboard:handleKeypress(key, scancode, is_repeat)
    table.insert(self.history, key:len() > 1 and " " or key)
    self.keyboard_state[key] = {
        key = key,
        index = #self.history
    }

    if #self.history > 100 then
        table.remove(self.history, 1)
    end
end

function keyboard:handleKeyReleased(key, scancode)
    self.keyboard_state[key] = nil
end

function keyboard:getKeyboardState()
    table.sort(self.keyboard_state, function(left_wing, right_wing)
        return left_wing.index > right_wing.index
    end)

    return self.keyboard_state
end

function keyboard:getKeyboardStateArray()
    local state = keyboard:getKeyboardState()
    local key_array = {}

    for _, key in pairs(state) do
        table.insert(key_array, key)
    end

    return key_array
end

function keyboard:validateKeystroke(key)
    self.validated_keystrokes[key.index] = true
end

function keyboard:isKeystrokeValidated(key_index)
    return self.validated_keystrokes[key_index]
end

return keyboard