local spike_col_dist = TILE_SIZE/1.7
-- local exit_col_dist = TILE_SIZE

function Player:update_collision(dt)
    local col_zones = Physics.col(self, {"zone"})
    if #col_zones > 0 then
        local zone = col_zones[1]
        if zone.value == "cam" then
            self.cam_x = zone.x+zone.w/2
            self.cam_y = zone.y+zone.h/2
        end
    end
    
    local col_pads = Physics.col(self, {"pad"})
    if #col_pads > 0 then
        self:pad_jump()
    end

    local col_spikes = Physics.dist(self, {"spike"}, spike_col_dist)
    if #col_spikes > 0 then
        self:die()
    end

    -- local col_event_boxes = Physics.col(self, {"event_box"})
    -- if #col_event_boxes > 0 then
    --     local event_box = col_event_boxes[1]
    --     event_box.data()
    -- end
end

function Player:die()
    for i = 0, 4 do
        Game:add(Particle, self.x+self.w/2, self.y+self.h/2, math.random(-10, 10), math.random(-10, 10), math.random(6, 12))
    end
    self.remove = true
    Camera:shake(3)
    Game:restart()
    -- Audio.die:play()
end

return Player