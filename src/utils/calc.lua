local calc = {}

function calc.getScaling(drawable, canvas)
	local canvas = canvas or nil

	local drawW = drawable:getWidth()
	local drawH = drawable:getHeight()

	local canvasW = 0
	local canvasH = 0
		
	if canvas then
		canvasW = canvas:getWidth()
		canvasH = canvas:getHeight()
	else
		canvasW = love.graphics.getWidth()
		canvasH = love.graphics.getHeight()
	end

	local scaleX = canvasW / drawW
	local scaleY = canvasH / drawH

	return scaleX, scaleY
end

return calc