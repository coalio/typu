local Video = {
    draw = nil,
    play = nil,

    video_object = nil
}

function Video:draw()
    local scale_x, scale_y = calc.getScaling(self.video_object)
    love.graphics.draw(self.video_object, 0, 0, 0, scale_x, scale_y)
end

function Video:play()
    self.video_object:play()
end

return class('Video', Video)