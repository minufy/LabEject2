local Player = Object:extend()

Player:implement(require("objects.lab.movement"))
Player:implement(require("objects.lab.draw"))
Player:implement(require("objects.lab.collision"))

NewImage("lab")

function Player:new(data)
    self:init_draw()
    self:init_movement()

    self.x = data.x
    self.y = data.y
    self.oh = Image.lab:getHeight()
    self.w = Image.lab:getWidth()
    self.h = self.oh
    
    if not Edit.editing then
        self.y = self.y-self.h+TILE_SIZE
        self.cam_x = self.x+self.w/2
        self.cam_y = self.y+self.h/2
        Camera:offset(Res.w/2, Res.h/2)
        Camera:set(self.cam_x, self.cam_y)
        Camera:snap_back()
    end
end

function Player:update(dt)
    -- follow player
    self.cam_x = self.x+self.w/2
    self.cam_y = self.y+self.h/2
    
    self:update_collision(dt)
    self:update_draw(dt)
    self:update_movement(dt)

    -- Game:add(Particle, self.x+self.w/2, self.y+self.h/2, 0, 0, 2)

    -- set camera after collision
    Camera:set(self.cam_x, self.cam_y)
end

function Player:draw()
    self:draw_draw()
end

return Player