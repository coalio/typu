local Text = {
    move = nil,
    draw = nil,
    isVisible = nil,
    eventHandler = nil,
    text = nil,
    font = nil,
    type = nil,

    
    pos = {
        x = nil,
        y = nil
    },

    mov = {
        vx = nil,
        vy = nil,
    }
}

function Text:move(x, y)
    self.pos.x = self.pos.x + (render.delta * (x * self.mov.vx))
    self.pos.y = self.pos.y + (render.delta * (y * self.mov.vy))
end

function Text:draw()
    love.graphics.setFont(self.font)
    love.graphics.print(self.text, self.pos.x, self.pos.y)
end

function Text:isVisible()
    return (
        self.pos.x + self.dim.w > 0 and self.pos.x < env.window.width and 
        self.pos.y + self.dim.h > 0 and self.pos.y < env.window.height
    )
end

function Text:isInRange()
    if (self.type == "lyric_dynamic" and self:isVisible()) then
        return (
            self.pos.x < manager.entities[2].pos.x and 
            self.pos.x + self.dim.w > manager.entities[1].pos.x
        )
    end
end

function Text:eventHandler(event)
    if (event.action == "move") then
        self:move(unpack(event.payload))
    end
end

return class('Text', Text, function(new_text)
    manager.entities:add(new_text)
end)