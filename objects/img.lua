local Img = Object:extend()

function Img:new(x, y, type)
    self.type = type
    self.x = x
    self.y = y
    self.w = IMG_TABLE[type]:getWidth()
    self.h = IMG_TABLE[type]:getHeight()
end

function Img:draw()
    love.graphics.draw(IMG_TABLE[self.type], self.x, self.y)
end

return Img