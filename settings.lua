Input.scan = NewInput({"r"})

Input.right = NewInput({"right", "d"})
Input.left = NewInput({"left", "a"})
-- Input.up = NewInput({"up", "w"})
Input.down = NewInput({"down", "s"})
Input.jump = NewInput({"space", "up", "w", "lshift"})

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
    "test",
}

TILE_SIZE = 16