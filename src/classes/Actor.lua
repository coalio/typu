local Actor = {
    move = nil,
    draw = nil
}

function Actor:move(x, y, delta)
    self.pos.x += x * (delta + self.mov.vx)
    self.pos.y += y * (delta + self.mov.vy)
end

function Actor:draw()
    self.draw()
end

return class('Actor', Actor)