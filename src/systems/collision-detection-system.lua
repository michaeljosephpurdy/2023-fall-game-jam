local CollisionDetectionSystem = tiny.processingSystem()
CollisionDetectionSystem.filter = tiny.requireAll('can_collide')

local function ignore_collision(a, b)
  --return b.x - a.x >= 32 and a.x - b.x <= 32
  return false
end

local function collides(a, b)
  return a.position.x + a.width >= b.position.x and
         a.position.x <= b.position.x + b.width and
         a.position.y + a.height >= b.position.y and
         a.position.y <= b.position.y + b.height
end

function CollisionDetectionSystem:init()
  self.tile_colliders = {}
  PubSub.subscribe('ldtk.level.load', function()
    self.tile_colliders = {}
  end)
  PubSub.subscribe('ldtk.collider.create', function(collider)
    table.insert(self.tile_colliders, {
      position = Vector.new(collider.x, collider.y),
      width = collider.width,
      height = collider.height
    })
  end)
end

function CollisionDetectionSystem:onAddToWorld(world)
end

function CollisionDetectionSystem:process(entity, dt)
  -- first, we'll reset all flags on the entity, saying that it has not collided
  entity.collisions = {}
  -- then, we'll loop through all (tile) colliders
  --  then, we'll loop through all (entity) collider offsets, using them to make new colliders
  --  if there are any collisions, then we'll set the flag on the entity
  for _, tile_collider in pairs(self.tile_colliders) do
    if ignore_collision(tile_collider, entity) then
      goto continue
    end
    if collides(tile_collider, entity) then
      entity.collisions['center'] = true
    end
    for direction, offset in pairs(entity.collider_offsets) do
      local collider = {
        position = entity.position + offset,
        width = 2,
        height = 2
      }
      if collides(tile_collider, collider) then
        entity.collisions[direction] = true
      end
    end
    ::continue::
  end
end

return CollisionDetectionSystem
