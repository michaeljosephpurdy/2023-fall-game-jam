local PlatformingSystem = tiny.processingSystem()
PlatformingSystem.filter = tiny.requireAll('platforming')

function PlatformingSystem:onAddToWorld(world)
end

function PlatformingSystem:process(e, dt)
  e.old_position = e.position:clone()
  local dx, dy = 0, 0
  if e.moving then
    e.velocity.x = e.speed * e.direction.x * dt
    if e.direction.x == 1 then
      --flip right
    else
      --flip left
    end
  else
    e.velocity.x = e.velocity.x * 0.9
  end
  if e.on_ground and e.jumping and e.velocity.y <= 0 then
    e.velocity.y = e.velocity.y - e.jump_force
  end
  if not e.on_ground then
    e.velocity.y = e.velocity.y + e.gravity * dt
  end
  e.position = e.position + e.velocity
end

return PlatformingSystem
