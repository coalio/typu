-- Globals
render --[[ render information ]] = {
    delta --[[ time between frames ]] = 0
}


local sdir = love.filesystem.getSourceBaseDirectory()
local dir = love.filesystem.getWorkingDirectory()

calc = require('src.utils.calc')
class = require('src.utils.class')
dump = require('src.utils.dump')
game = require('src.game')
gradient = require('src.utils.gradient')
loader = require('src.loader')
keyboard = require('src.keyboard')
manager = require('src.manager')

function love.load()
    love.window.setVSync(1)
    love.window.setFullscreen(true)
    require('src.utils.env')
    -- Load classes 
    Entity = require('src.classes.Entity')
    Video = require('src.classes.Video')
    Background = require('src.classes.Background')
    Event = require('src.classes.Event')
    Text = require('src.classes.Text')
    -- Load entities
    require('src.entities.index')
    -- Finally, begin

    -- Load example map_data
    local map_data = loader:deserialize('maps/nice.typu')
    game:play(map_data)
end

function love.draw()
    game:draw()
end

function love.update(delta)
    render.delta = delta
    render.avdelta = love.timer.getAverageDelta()
    game:update()
    manager:eventHandler()
end

function love.keypressed(key, scancode, is_repeat)
    keyboard:handleKeypress(key, scancode, is_repeat)
end