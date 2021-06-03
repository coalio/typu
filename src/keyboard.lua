local keyboard = {
    history = {},
    keyboard_state = {} --[[ Behaves like SDL::GetKeyboardState ]]
}

function keyboard:handleKeypress(key, scancode, is_repeat)
    table.insert(self.history, key)
    self.keyboard_state[key] = #self.history
end

function keyboard:handleKeyReleased(key, scancode)
    self.keyboard_state[key] = nil
end

function keyboard:getKeystrokes()
    -- Order this, first keystroke first
    table.sort(self.keyboard_state, function(a,b) return a > b end)
    return self.keyboard_state
end

return keyboard