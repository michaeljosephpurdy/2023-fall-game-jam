local PlayerControllerSystem = tiny.processingSystem()
PlayerControllerSystem.filter = tiny.requireAll('controllable')

function PlayerControllerSystem:process(e, dt)
    e.platforming.moving = false
    e.platforming.direction = 0

    local left = love.keyboard.isDown('left')
    local right = love.keyboard.isDown('right')

    if left or right then
        e.platforming.moving = true
    end
    if right then
        e.platforming.direction = 1
    end
    if left then
        e.platforming.direction = -1
    end

    e.platforming.jumping = love.keyboard.isDown('space')
end

return PlayerControllerSystem
