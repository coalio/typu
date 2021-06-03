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
    love.graphics.setFont(love.graphics.newFont(16))
    love.graphics.print(math.floor(self.pos.x) .. ' ' .. 
        (self:getSubInRange().string and self:getSubInRange().string:sub(self:getSubOffRange().at or 1, -1) or 'out-of-range'),
        self.pos.x, self.pos.y-56
    )
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
            self.pos.x > manager.entities[1].pos.x
        )
    end
end

function Text:colorTextAt(start_at, end_at)
    -- https://love2d.org/wiki/Text
end

function Text:eventHandler(event)
    if (event.action == "move") then
        self:move(unpack(event.payload))
    end
end

function Text:getSubInRange()
    local min_sub = {width = 0}

    for index, sub in pairs(self.sub) do
        if (
            sub.width > min_sub.width and
            self.pos.x + sub.width < manager.entities[2].pos.x 
        ) then
            min_sub = sub
        end
    end

    return min_sub
end

function Text:getSubOffRange()
    local min_sub = {width = 0}

    for index, sub in pairs(self.sub) do
        if (
            sub.width > min_sub.width and
            self.pos.x + sub.width < manager.entities[1].pos.x
        ) then
            min_sub = sub
        end
    end

    return min_sub
end

function Text:updateSubs(caret_pos)
    local text_len = self.text:len()

    self.sub = {}
    local caret_pos = caret_pos or 1
    for at = caret_pos, text_len do
        local string = self.text:sub(caret_pos, at)
        self.sub[at] = {
            at = at,
            string = string,
            width = self.font:getWidth(string)
        }
    end

    return self.sub
end

function Text:getCharArray()
    local char_array = {}

    for char in self.text:gmatch('(.)') do
        table.insert(char_array, char)
    end

    return char_array
end

return class('Text', Text, function(new_text)
    new_text.sub = {}

    for at, character in new_text.text:gmatch('()(.)') do
        local string = new_text.text:sub(1, at)
        new_text.sub[at] = {
            at = at,
            string = string,
            width = new_text.font:getWidth(string)
        }
    end

    manager.entities:add(new_text)

    return new_text
end)