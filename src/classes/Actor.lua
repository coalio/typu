local Actor = {
    move = nil,
    draw = nil,
    isVisible = nil,
    eventHandler = nil,
    
    pos = {
        x = nil,
        y = nil
    },

    mov = {
        vx = nil,
        vy = nil,
    }
}

function Actor:move(x, y)
    self.pos.x = self.pos.x + x * (render.delta + self.mov.vx)
    self.pos.y = self.pos.y + y * (render.delta + self.mov.vy)
end

function Actor:draw()
    self:draw()
end

function Actor:isVisible()
    return (
        self.pos.x + self.dim.w > 0 and self.pos.x < env.window.width and 
        self.pos.y + self.dim.h > 0 and self.pos.y < env.window.height
    )
end

function Actor:eventHandler(event)
    if (event.type == "move") then
        self:move(table.unpack(event.payload))
    end
end

return class('Actor', Actor, function(new_actor)
    manager.actors_list:add(new_actor)
end)