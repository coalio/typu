local Video = {
    draw = nil,
    play = nil,

    _stream = nil
}

function Video:draw()
    local scale_x, scale_y = calc.getScaling(self._stream)
    love.graphics.draw(self._stream, 0, 0, 0, scale_x, scale_y)
end

function Video:play()
    self._stream:play()
end

return class('Video', Video)