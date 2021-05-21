-- Create a new actor, rangeline has its own custom functions

local rangeline_prototype = {
    id = 2,
    type = "dynamic",
    name = "rangeline",

    pos = {
        x = env.window.width / 5, -- This is the default position
        y = 0
    },

    dim = {
        w = 1,
        h = env.window.height
    },

    mov = {
        vx = 2,
        vy = 0
    }
}

function rangeline_prototype:draw()
    -- The rangeline is just a line
    love.graphics.line(self.pos.x, self.pos.y, self.pos.x, self.dim.h)
end

Actor:new(rangeline_prototype)