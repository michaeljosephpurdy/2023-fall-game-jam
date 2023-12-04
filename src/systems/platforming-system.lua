local PlatformingSystem = tiny.processingSystem()
PlatformingSystem.filter = tiny.requireAll('platforming')

function PlatformingSystem:onAddToWorld(world)
end

function PlatformingSystem:process(e, dt)
  if e.moving then
    if e.direction.x == 1 then
      e.velocity.x = math.min(e.speed, e.velocity.x + e.acceleration * dt)
    else
      e.velocity.x = math.max(-e.speed, e.velocity.x - e.acceleration * dt)
    end
  elseif e.on_ground then
    if e.velocity.x > 0 then
      e.velocity.x = math.max(0, e.velocity.x - e.friction * dt)
    elseif e.velocity.x < 0 then
      e.velocity.x = math.min(0, e.velocity.x + e.friction * dt)
    end
  end
  if e.jumping and e.on_ground then
    e.velocity.y = -e.jump
    e.on_ground = false
  end
end

return PlatformingSystem
