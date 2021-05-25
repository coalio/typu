-- Create a new entity, borderline has its own custom functions

local borderline_prototype = {
    id = 1,
    type = "static",
    name = "borderline",

    pos = {
        x = env.window.width / 6,
        y = 0
    },

    dim = {
        w = 1,
        h = env.window.height
    },

    mov = {
        vx = 0,
        vy = 0
    }
}

function borderline_prototype:draw()
    -- The borderline is just a line
    love.graphics.line(self.pos.x, self.pos.y, self.pos.x, self.dim.h)
end

Entity:new(borderline_prototype)