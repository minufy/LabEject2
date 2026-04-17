local img = NewImage("player")
local bounce_damp = 0.2

function Player:init_draw()
    self.flip = 1
end

function Player:update_draw(dt)
    local flip = 0
    if Input.right.down then
        flip = flip+1
    end
    if Input.left.down then
        flip = flip-1
    end
    if flip ~= 0 then
        self.flip = flip
    end

    self.draw_bounce = self.draw_bounce+(0-self.draw_bounce)*bounce_damp*dt
end

function Player:draw_draw()
    local sx = (1-self.draw_bounce)
    local sy = (1+self.draw_bounce)
    local ox = self.w*(1-self.flip*sx)/2
    local oy = -self.draw_bounce*self.h
    -- if Input.down.down then
    --     oy = 0
    -- end
    love.graphics.draw(img, self.x+ox, self.y+oy, 0, self.flip*sx, sy)
    -- love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end

return Player