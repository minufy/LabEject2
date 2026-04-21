local Img = Object:extend()

function Img:new(x, y, type)
    self.type = type
    self.x = x
    self.y = y
    self.w = Image["img."..type]:getWidth()
    self.h = Image["img."..type]:getHeight()
end

function Img:draw()
    love.graphics.draw(Image["img."..self.type], self.x, self.y)
end

return Img