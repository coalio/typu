-- Globals
render --[[ render information ]] = {
    delta --[[ time between frames ]] = 0
}

local sdir = love.filesystem.getSourceBaseDirectory()
local dir = love.filesystem.getWorkingDirectory()

love.window.setFullscreen(true)
require('src.utils.env')
calc = require('src.utils.calc')
class = require('src.utils.class')
dump = require('src.utils.dump')
memoization = require('src.utils.memoization')
gradient = require('src.utils.gradient')
game = require('src.game')
interface = require('src.interface')
loader = require('src.loader')
keyboard = require('src.keyboard')
manager = require('src.manager')
event_master = require('src.event_master')

function love.load()
    if (env.muted) then
        love.audio.setVolume(0)
    end

    -- love.window.setVSync(1)
    -- Load classes 
    Entity = require('src.classes.Entity')
    Video = require('src.classes.Video')
    Background = require('src.classes.Background')
    Event = require('src.classes.Event')
    Keystrokes = require('src.classes.Keystrokes')
    -- Load entities
    require('src.entities.index')
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

function love.keyreleased(key, scancode)
    keyboard:handleKeyReleased(key, scancode)
end