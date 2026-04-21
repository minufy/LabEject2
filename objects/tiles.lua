local Tiles = Object:extend()

function Tiles:new(tiles)
    self.tiles = tiles
    self.xs = {}
    self.ys = {}
    self:init_tiles()
end

function Tiles:init_tiles()
    for key, _ in pairs(self.tiles) do
        local x, y = self:key_to_pos(key)
        self.xs[key] = x
        self.ys[key] = y
    end
end

function Tiles:key_to_pos(key)
    local x, y = string.match(key, "([^,]+),([^,]+)")
    return tonumber(x), tonumber(y)
end

function Tiles:around(x, y)
    local found = {}
    for fx = x-1, x+1 do
        for fy = y-1, y+1 do
            if self.tiles[fx..","..fy] ~= nil then
                table.insert(found, {x = fx*TILE_SIZE, y = fy*TILE_SIZE, w = TILE_SIZE, h = TILE_SIZE})
            end
        end
    end
    return found
end

function Tiles:draw()
    for key, tile in pairs(self.tiles) do
        love.graphics.draw(Image["tile."..tile], self.xs[key]*TILE_SIZE, self.ys[key]*TILE_SIZE)
    end
end

return Tiles