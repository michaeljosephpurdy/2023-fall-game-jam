local CollisionResolutionSystem = tiny.processingSystem()
CollisionResolutionSystem.filter = tiny.requireAll('can_collide')

function CollisionResolutionSystem:init()
end

function CollisionResolutionSystem:onAddToWorld(world)
end

function CollisionResolutionSystem:process(e, dt)
  if not e.collisions.center then return end
  if e.collisions.left and e.direction.x == -1 then
    if e.velocity.x <= 0 then e.velocity.x = 0 end
    e.position.x = e.old_position.x
  end
  if e.collisions.right and e.direction.x == 1 then
    if e.velocity.x >= 0 then e.velocity.x = 0 end
    e.position.x = e.old_position.x
  end
  if e.collisions.down and not e.on_ground then
    e.position.y = e.old_position.y
    e.on_ground = true
  end
end

return CollisionResolutionSystem
