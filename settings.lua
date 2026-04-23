Input.right = NewInput({"right", "d"})
Input.left = NewInput({"left", "a"})
Input.down = NewInput({"down", "s"})
Input.jump = NewInput({"space", "up", "w"})
Input.dash = NewInput({"lshift"})
Input.down_dash = NewInput({"s"})

Camera.x_damp = 0.2
Camera.y_damp = 0.2
Camera.shake_damp = 0.2

TILE_TYPES = {
    "tile",
}
OBJECT_TYPES = {
    "player",
    "zone",
}
IMG_TYPES = {
}

TILE_SIZE = 16

local object_align = {
    player = Bottom,
}
OBJECT_ALIGN = setmetatable(object_align, {
    __index = function (t, k)
        return None
    end
})