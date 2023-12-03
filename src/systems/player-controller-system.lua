local PlayerControllerSystem = tiny.processingSystem()
PlayerControllerSystem.filter = tiny.requireAll('controllable')

function PlayerControllerSystem:process(e, dt)
  e.moving = false
  e.direction = Vector.new(0, 0)

  local left = love.keyboard.isDown('left')
  local right = love.keyboard.isDown('right')

  if left or right then
    e.moving = true
  end
  if right then
    e.direction.x = 1
  end
  if left then
    e.direction.x = -1
  end

  e.jumping = love.keyboard.isDown('space')
end

return PlayerControllerSystem
