local speed = 1.47
local air_speed = 1.6
local gravity = 0.42
local jump_force = 4.1
local pad_jump_force = 8.3
local max_vy = 6
local min_vy = -6
local acc_damp = 0.1
local dec_damp = 0.1
local vx_damp = 0.3
local vx_dec = 0.18
local falling = 5
local jump_buffer = 10
local draw_bounce = 0.5
local particle = 5
local wall_speed = 0.8
local wall_jump_force = 4.5
local wall_jump_mult = 0.75

function Player:init_movement()
    self.mx = 0
    self.vx = 0
    self.vy = 0
    self.falling = 999
    self.jump_buffer = 999
    self.wall_side = 0
    self.gravity = gravity
    self.speed = speed

    self.draw_bounce = 0
    self.particle = 0
    self.wall_particle = false
end

function Player:col_other(found_other, found, cb)
    for i, col in ipairs(found_other) do
        if tostring(col) == "switch" or tostring(col) == "switch_block" and col.soild then
            table.insert(found, col)
        end
        if cb then
            cb(col)
        end
    end
end

function Player:update_movement(dt)
    local ix = 0
    if Input.right.down then
        ix = ix+1
    end
    if Input.left.down then
        ix = ix-1
    end

    if self.falling < falling and Input.down.down then
        self.draw_bounce = -draw_bounce
        ix = 0
    end

    if ix == 0 then
        self.mx = self.mx+(ix-self.mx)*dec_damp*dt
    else
        self.mx = self.mx+(ix-self.mx)*acc_damp*dt
    end

    if Sign(self.vx) == Sign(self.mx) then
        self.vx = self.vx-self.vx*vx_damp*dt
    else
        self.vx = self.vx-Sign(self.vx)*vx_dec*dt
    end

    if self.falling > falling then
        self.speed = air_speed
    else
        self.speed = speed
    end

    local found_x = Physics.move_and_col(self, (self.vx+self.mx*self.speed)*dt, 0)
    local found_other_x = Physics.col(self, {"switch", "switch_block"})
    Player:col_other(found_other_x, found_x)
    Physics.solve_x(self, self.vx+self.mx*self.speed, found_x[1])
    if #found_x > 0 then
        self.vy = math.min(self.vy, wall_speed)
        self.wall_side = Sign(found_x[1].x-self.x)
        self.falling = 0
        self.wall_particle = true
    else
        self.wall_particle = false
    end
    
    self.vy = self.vy+self.gravity*dt
    if self.vy >= max_vy then
        self.vy = max_vy
    end
    if self.vy <= min_vy then
        self.vy = min_vy
    end
    local found_y = Physics.move_and_col(self, 0, self.vy*dt)
    local found_other_y = Physics.col(self, {"switch", "switch_block"})
    Player:col_other(found_other_y, found_y, function (col)
        if tostring(col) == "switch" and self.vy < 0 then
            for _ = 0, 4 do
                Game:add(Particle, self.x+self.w/2, self.y, math.random(-12, 12), math.random(0, 5), math.random(2, 4))
            end
            col:col()
        end
    end)
    Physics.solve_y(self, self.vy, found_y[1])
    if #found_y > 0 then
        if self.vy > 0 then
            if self.falling > falling then
                self.draw_bounce = -draw_bounce
                for _ = 0, 4 do
                    Game:add(Particle, self.x+self.w/2, self.y+self.h, math.random(-12, 12), math.random(-5, 0), math.random(2, 4))
                end
                -- Audio.land:play()
            end
            self.wall_side = 0
            self.falling = 0
        end
        self.vy = 0
    end
    self.falling = self.falling+dt
    self.jump_buffer = self.jump_buffer+dt

    if Input.jump.pressed then
        self.jump_buffer = 0
    end
    if self.jump_buffer <= jump_buffer then
        self:jump()
    end
    if Input.jump.down then
        self.gravity = gravity/2
    else
        self.gravity = gravity
    end

    if ix ~= 0 and self.falling <= falling and #found_x == 0 or self.wall_particle then
        self.particle = self.particle+dt
        if self.particle > particle then
            self.particle = 0
            Game:add(Particle, self.x+self.w/2, self.y+self.h, ix*math.random(0, 10), math.random(-5, 0), math.random(2, 4))
        end
    end
end

function Player:jump()
    if self.falling <= falling then
        -- Audio.jump:play()
        if self.wall_side ~= 0 then
            self.vx = -self.wall_side*wall_jump_force
            self.vy = -jump_force*wall_jump_mult
            self.wall_side = 0
        else
            self.vy = -jump_force
        end
        self.draw_bounce = draw_bounce
        self.falling = 999
        self.jump_buffer = 999
        for _ = 0, 4 do
            Game:add(Particle, self.x+self.w/2, self.y+self.h, math.random(-15, 15), math.random(-10, 0), math.random(2, 6))
        end
    end
end

function Player:pad_jump()
    self.vy = -pad_jump_force
    self.draw_bounce = draw_bounce
    self.falling = 999
    self.jump_buffer = 999
    for _ = 0, 4 do
        Game:add(Particle, self.x+self.w/2, self.y+self.h, math.random(-15, 15), math.random(-10, 0), math.random(2, 6))
    end
end

return Player