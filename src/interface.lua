local interface = {}

function interface.drawGradients()
    gradient.draw(game.background.gradient_bottom, 0, env.window.height - 100, env.window.width, 100)
    gradient.draw(game.background.gradient_top, 0, 0, env.window.width, 200)
end

function interface.drawLyricsPreview()
    if (game.current.next_instruction and game.current.next_instruction.text) then
        -- text
        love.graphics.setFont(game.preview_font)
        love.graphics.print(
            game.current.next_instruction.text,
            10,
            env.window.height - 54
        )
    end

    if (game.current.instruction.text and game.current.instruction_index ~= 1) then
        love.graphics.setFont(game.current_font)
        love.graphics.print(
            game.current.instruction.text,
            10,
            env.window.height - 36
        )
    end

    if (game.current.keystrokes and game.current.keystrokes ~= '') then
        local old_color = table.pack(love.graphics.getColor())
        love.graphics.setColor(255, 255, 255, 0.4)
        love.graphics.setFont(game.preview_keystroke_font)
        love.graphics.print(
            game.current.keystrokes,
                env.window.width / 2 - 
                game.preview_keystroke_font:getWidth(game.current.keystrokes) / 2 + 
                game.current.keystrokes_offset,
            env.window.height / 2 + 50
        )
        love.graphics.setColor(unpack(old_color))
    end
end

return interface