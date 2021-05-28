local Text = {
    move = nil,
    draw = nil,
    isVisible = nil,
    eventHandler = nil,
    text = nil,
    font = nil,
    type = nil,
    _text = nil,

    sub = {},

    pos = {
        x = nil,
        y = nil
    },

    mov = {
        vx = nil,
        vy = nil,
    },

    dim = {
        w = nil,
        h = nil
    }
}

-- Add colored text
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

function Text:isOutOfBounds()
    return self.pos.x + self.dim.w < 0
end

function Text:destroy()
    manager.entities:delete(self.id)
end

function Text:isInRange()
    if (self.type == "lyric_dynamic") then
        return (
            self.pos.x < manager.entities[2].pos.x and 
            self.pos.x + self.dim.w > manager.entities[1].pos.x
        )
    end
end

function Text:colorTextAt(start_at, end_at)
    -- https://love2d.org/wiki/Text:add
end

function Text:eventHandler(event)
    if (event.action == "move") then
        self:move(unpack(event.payload))
    end
end

function Text:getSubInRange()
    local min_sub = 0
    for index, sub in pairs(self.sub) do
        if (
            sub.width > min_sub and
            self.pos.x + sub.width < manager.entities[2].pos.x 
        )
        -- if the sub is inside range then make this min sub
    end
end

return class('Text', Text, function(new_text)
    manager.entities:add(new_text)

    for character, at in new_text.text:gmatch('.()') do
        local string = new_text.text:sub(1, at)
        new_text.sub[at] = {
            string = string,
            width = new_text.font:getWidth(string)
        }
    end

    return new_text
end)