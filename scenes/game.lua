Game = {}

function Game:add(Object, ...)
    local o = Object(...)
    local group_name = tostring(o)
    if self.objects[group_name] == nil then
        self.objects[group_name] = {}
    end
    table.insert(self.objects[group_name], o)
    return o
end

function Game:init()
    Edit:init()
    Level:init()
end

function Game:reset()
    self.objects = {}
end

function Game:update(dt)
    Edit:update(dt)

    if not Edit.editing then
        for group_name, _ in pairs(self.objects) do
            for i = #self.objects[group_name], 1, -1 do
                local object = self.objects[group_name][i]
                if object.update then
                    object:update(dt)
                end
                if object.remove then
                    table.remove(self.objects[group_name], i)
                end
            end
        end
    end
end

function Game:draw()
    love.graphics.setColor(rgb(117, 117, 117))
    love.graphics.rectangle("fill", 0, 0, Res.w, Res.h)
    ResetColor()
    
    Camera:start()
    -- Shader:start()
    
    for group_name, group in pairs(self.objects) do
        for _, object in ipairs(group) do
            if object.draw then
                object:draw()
            end
        end
    end
    
    if Edit.editing then
        Edit:draw()
    end
    
    Camera:stop()

    if Edit.editing then
        Edit:draw_hud()
    end

    -- Shader:stop()
end

return Game