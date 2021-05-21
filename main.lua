-- Globals
render --[[ render information ]] = {
    delta --[[ time between frames ]] = 0
}


local sdir = love.filesystem.getSourceBaseDirectory()
local dir = love.filesystem.getWorkingDirectory()

class = require('src.utils.class')
game = require('src.game')
manager = require('src.manager')
loader = require('src.loader')

function love.load()
    love.window.setFullscreen(true)
    require('src.utils.env')
    -- Load classes
    Actor = require('src.classes.Actor')
    -- Load actors
    require('src.actors.index')
    -- Finally, begin

    -- Load example map_data
    loader:deserialize('maps/nice.typu')
end

function love.draw()
    for id, actor in pairs(manager.actors_list:getDrawable()) do
        actor:draw()
    end
end

function love.update(delta)
    render.delta = delta
end