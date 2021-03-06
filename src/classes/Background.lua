local Background = {
    draw = nil,
    video = nil,
    gradient_bottom = nil,
    gradient_top = nil
}

function Background:draw()
    self.video:draw()
    local original_color = table.pack(love.graphics.getColor())
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle('fill', 0, 0, env.window.width, env.window.height)
    love.graphics.setColor(unpack(original_color))
end

return class('Background', Background, function(new_background)
    new_background.gradient_bottom = gradient.create('vertical', {
        0, 0, 0, 0
    }, {
        0, 0, 0, 1
    }, {
        0, 0, 0, 1
    })
    
     new_background.gradient_top = gradient.create('vertical', {
        0, 0, 0, 1
    }, {
        0, 0, 0, 0
    })

    return new_background
end)