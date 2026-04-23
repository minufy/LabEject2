local Particle = Object:extend()

function Particle:new(x, y, mx, my, size, color)
    self.x = x
    self.y = y

    self.mx = mx*0.1
    self.my = my*0.1
    
    self.size = size
    self.color = color or {1, 1, 1}
end

function Particle:draw()
    love.graphics.setColor(self.color)
    love.graphics.circle("fill", self.x, self.y, self.size)
    Color.reset()
end

function Particle:update(dt)
    self.x = self.x+self.mx*dt
    self.y = self.y+self.my*dt

    self.mx = self.mx+(0-self.mx)*0.1*dt
    self.my = self.my+(0-self.my)*0.1*dt
    
    self.size = self.size+(0-self.size)*0.07*dt
    if self.size < 0.5 then
        self.remove = true
    end
end

return Particle