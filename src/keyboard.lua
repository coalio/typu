local keyboard = {
    history = {}
}

function keyboard:handleKeypress(key, scancode, is_repeat)
    table.insert(self.history, key)

    if (game.currently_playing) then
        -- check if keypress is in sentence range and order
    end
end

return keyboard