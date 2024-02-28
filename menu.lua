local Menu = {}
Menu.__index = Menu

function Menu.new(manager)
    local menu = setmetatable({}, Menu)
    menu.manager = manager
    return menu
end

function Menu:update(dt)
    if love.keyboard.isDown("space") then
        return "game"
    end
end

function Menu:draw()
    local screenX, screenY = love.window.getMode()
    love.graphics.print("Bullet Hell", BigFont, screenX / 2 - 100, screenY / 2 - 120)
    love.graphics.print("Press Space to Start", RegularFont, screenX / 2 - 130, screenY / 2 + 120)
end

return Menu
