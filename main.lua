local lurker = require("modules.lurker")
lurker.postswap = function(f)
    Log("File " .. f .. " was swapped")
end

Object = require("modules.classic")
Particle = require("objects.particle")

require("stuff.physics")
require("stuff.camera")
require("stuff.input")
require("stuff.res")
require("stuff.utils")
require("stuff.log")
require("stuff.audio")
require("stuff.edit")
require("stuff.level")
require("stuff.mouse")
require("stuff.selection")
require("stuff.shader")

require("scenes.sm")
require("settings")

function love.load()
    LogFont = love.graphics.newFont(10)
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setLineStyle("rough")
    Font = love.graphics.newFont("assets/fonts/Galmuri9.ttf", 10)

    -- NewAudio("jump")

    Shader:init("assets/shader/shadow.glsl")
    Res:init()
    SM:load("game")
    UpdateTargetFPS()
end

local last = 0
function love.update(dt)
    local now = love.timer.getTime()
    local elapsed = now-last
    if elapsed < 1/TargetFPS then
        love.timer.sleep(1/TargetFPS-elapsed)
    end
    last = love.timer.getTime()
    dt = math.min(dt*60, 1.5)
    UpdateInputs()
    Camera:update(dt)
    SM:update(dt)
    ResetWheelInput()
    UpdateLog(dt)
    if CONSOLE and Input.ctrl.down and Input.scan.pressed then
        Level:reload()
        lurker.scan()
    end
end

function love.draw()
    Res:before()
    SM:draw()
    Res:after()
    DrawLog()
    if CONSOLE then
        love.graphics.print(tostring(love.timer.getFPS()))
    end
end