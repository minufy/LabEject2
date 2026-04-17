WINDOW_W = 800
WINDOW_H = 600
CONSOLE = true

function love.conf(t)
    t.window.resizable = true
    t.console = CONSOLE
    t.window.width = WINDOW_W
    t.window.height = WINDOW_H
    t.window.vsync = 0
end