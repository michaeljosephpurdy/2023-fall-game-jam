local CollisionResolutionSystem = tiny.processingSystem()
CollisionResolutionSystem.filter = tiny.requireAll('can_collide')

function CollisionResolutionSystem:init()
end

function CollisionResolutionSystem:onAddToWorld(world)
end

local function snap_to_grid(i)
  return math.floor(i / 16) * 16
end

function CollisionResolutionSystem:process(e, dt)
  if not e.collisions.center then return end
  if e.collisions.left and e.direction.x == -1 then
    if e.velocity.x <= 0 then
      e.velocity.x = 0
    end
    e.position.x = snap_to_grid(e.old_position.x)
    print(string.format('%s snapped to %s', e.old_position.x, e.position.x))
  end
  if e.collisions.right and e.direction.x == 1 then
    if e.velocity.x >= 0 then
      e.velocity.x = 0
    end
    e.position.x = snap_to_grid(e.old_position.x + e.width)
    print(string.format('%s snapped to %s', e.old_position.x, e.position.x))
  end
  if e.collisions.down and not e.on_ground then
    e.position.y = e.old_position.y--snap_to_grid(e.old_position.y)
    e.on_ground = true
  end
end

return CollisionResolutionSystem
