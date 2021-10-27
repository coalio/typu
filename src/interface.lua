local interface = {}

function interface.drawGradients()
    gradient.draw(game.background.gradient_bottom, 0, env.window.height - 100, env.window.width, 100)
    gradient.draw(game.background.gradient_top, 0, 0, env.window.width, 200)
end

function interface.drawLyricsPreview()
    local old_color = table.pack(love.graphics.getColor())
    love.graphics.setColor(255, 255, 255, 0.4) -- Preview is semi-transparent
    if (game.current.next_instruction and game.current.next_instruction.lyrics) then
        -- text
        love.graphics.setFont(game.preview_font)
        love.graphics.printf(
            game.current.next_instruction.lyrics,
            0,
            env.window.height - 50,
            env.window.width,
            'center'
        )
    end

    love.graphics.setColor(255, 255, 255, 0.7)
    if (game.current.instruction.text) then
        -- text
        love.graphics.setFont(game.current_font)
        love.graphics.printf(
            game.current.instruction.text,
            0,
            env.window.height - 80,
            env.window.width,
            'center'
        )
    end
    love.graphics.setColor(unpack(old_color))

    if (game.current.keystrokes and game.current.keystrokes ~= '') then
        local old_color = table.pack(love.graphics.getColor())
        local keystrokes_rect_width = game.preview_keystroke_font:getWidth(game.current.keystroke.original)
        love.graphics.setFont(game.preview_keystroke_font)
        love.graphics.printf(
            game.current.keystrokes,
            env.window.width / 2 - 
            keystrokes_rect_width / 2,
            env.window.height - 140,
            keystrokes_rect_width,
            'right'
        )
    end
end

function interface.drawHistory()
    love.graphics.setFont(game.preview_font)
    history_width = env.window.width - 102

    love.graphics.printf(
        keyboard.history,
        env.window.width / 2 - history_width / 2,
        10,
        history_width,
        'left'
    )
end

return interface