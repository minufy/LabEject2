local Zone = Object:extend()

function Zone:new(data)
    self.x = data.x
    self.y = data.y
    self.w = data.w or TILE_SIZE
    self.h = data.h or TILE_SIZE
    self.value = data.value or "test"
    self.locked = true
end

function Zone:draw()
    if Edit.editing then
        love.graphics.setColor(0, 1, 1, 0.1)
        love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
        ResetColor()
        love.graphics.setFont(Font)
        love.graphics.print(self.value, self.x, self.y)
    end
end

return Zone