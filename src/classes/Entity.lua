local Entity = {
    move = nil,
    draw = nil,
    isVisible = nil,
    eventHandler = nil,
    name = nil,
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

function Entity:move(x, y)
    self.pos.x = self.pos.x + (render.delta * (x * self.mov.vx))
    self.pos.y = self.pos.y + (render.delta * (y * self.mov.vy))
end

function Entity:draw()
    self:draw()
end

function Entity:isVisible()
    return (
        self.pos.x + self.dim.w > 0 and self.pos.x < env.window.width and 
        self.pos.y + self.dim.h > 0 and self.pos.y < env.window.height
    )
end

function Entity:eventHandler(event)
    if (event.action == "move") then
        self:move(unpack(event.payload))
    end
end

return class('Entity', Entity, function(new_entity)
    manager.entities:add(new_entity)
end)