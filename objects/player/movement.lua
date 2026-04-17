local speed = 2.3
local air_speed = 2.2
local gravity = 0.09
local jump_force = 3.2
local max_vy = 6
local min_vy = -6
local acc_damp = 0.1
local dec_damp = 0.12
local air_acc_damp = 0.15
local vx_damp = 0.15
local vx_slow_damp = 0.1
local falling = 5
local jump_buffer = 10
local draw_bounce = 0.5
local particle = 5
local wall_speed = 1
local wall_return_time = 18
local wall_jump_force = 2.5
local wall_jump_mult = 0.97
local cut_time = 10
local dash_time = 8
local dash_force = 4.4
local down_dash_time = 9
local down_dash_force = 3.5
local dash_reset_time = 60

function Player:init_movement()
    self.mx = 0
    self.vx = 0
    self.vy = 0
    self.falling = 999
    self.jump_buffer = 999
    self.wall_side = 0
    self.wall_return_time = 0
    self.dash_time = 0
    self.dashing = false
    self.down_dash_time = 0
    self.down_dashing = false
    self.dash_reset_time = 0
    self.gravity = gravity
    self.speed = speed
    self.last_ix = 0
    self.double_jump = false

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

    if ix ~= 0 then
        self.last_ix = ix
    end
    
    if ix == self.wall_side then
        if self.wall_return_time > 0 then
            ix = 0
        end
    end
    
    if self.dash_reset_time < 0 then
        if Input.dash.pressed then
            self.dash_reset_time = dash_reset_time
            self.dashing = true
            self.dash_time = dash_time
            self.wall_return_time = 0
            self.vx = self.last_ix*dash_force
        end
        if Input.down_dash.pressed then
            self.dash_reset_time = dash_reset_time
            self.down_dashing = true
            self.down_dash_time = down_dash_time
            self.vy = down_dash_force
        end
    else
        self.dash_reset_time = self.dash_reset_time-dt
    end

    if self.dash_time > 0 then
        self.dash_time = self.dash_time-dt
        ix = 0
        self.vy = 0
    else
        if ix ~= 0 and self.wall_return_time <= 0 then
            self.vx = self.vx-self.vx*vx_damp*dt
        end
        if self.dashing then
            if ix == 0 then
                self.vx = 0
            end
            self.dashing = false
        end
    end
    if self.down_dash_time > 0 then
        self.down_dash_time = self.down_dash_time-dt
        self.vy = down_dash_force
    elseif self.down_dashing then
        self.down_dashing = false
        self.vy = 0
    end

    if self.wall_return_time > 0 then
        self.wall_return_time = self.wall_return_time-dt
    elseif ix ~= 0 then
        self.vx = self.vx-self.vx*vx_damp*dt
    end

    if Sign(ix) == Sign(self.vx) then
        self.vx = self.vx-self.vx*vx_slow_damp*dt
    end

    if self.falling > falling then
        self.speed = air_speed
        if ix ~= 0 then
            self.mx = self.mx+(ix-self.mx)*air_acc_damp*dt
        end
    else
        self.speed = speed
        if self.dash_time <= 0 then
            self.vx = 0
        end
        if self.wall_side == 0 then
            if Input.down.down then
                self.draw_bounce = -draw_bounce
                ix = 0
            end
            -- local hx = (1+self.draw_bounce)
            -- if Input.down.pressed then
            --     self.h = self.oh*hx
            --     self.y = self.y+(self.oh-self.h)
            -- elseif Input.down.released then
            --     self.y = self.y-(self.oh-self.h)
            --     self.h = self.oh
            -- end
        end
        if ix == 0 then
            self.mx = self.mx+(ix-self.mx)*dec_damp*dt
        else
            self.mx = self.mx+(ix-self.mx)*acc_damp*dt
        end
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
            self.double_jump = true
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
    -- if Input.jump.down then
    --     self.gravity = gravity/2
    -- else
    --     self.gravity = gravity
    -- end
    if Input.jump.released and self.vy < 0 and self.wall_side == 0 then
        self.vy_cut = true
    end
    if self.vy_cut and self.falling > 999+cut_time then
        self.vy = 0
        self.vy_cut = false
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
    if self.falling <= falling or self.double_jump then
        if self.double_jump and self.falling > falling then
            self.double_jump = false
        end
        -- Audio.jump:play()
        if self.wall_side ~= 0 then
            self.wall_return_time = wall_return_time
            self.vx = -self.wall_side*wall_jump_force
            self.vy = -jump_force*wall_jump_mult
            self.mx = 0
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

return Player