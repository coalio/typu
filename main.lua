local sdir = love.filesystem.getSourceBaseDirectory()
local dir = love.filesystem.getWorkingDirectory()

function love.load()
    class = require('src.utils.class')
    game = require('src.game')
    manager = require('src.manager')

    require('src.utils.env')
end

function love.draw()

end

function love.update()

end