local CollisionDetectionSystem = tiny.processingSystem()
CollisionDetectionSystem.filter = tiny.requireAll('can_collide')

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

local function snap_to_grid(i)
  return math.floor(i / 16) * 16
end

function CollisionDetectionSystem:process(entity, dt)
  -- first, we'll reset all flags on the entity, saying that it has not collided
  entity.collisions = {}
  -- then, we'll loop through all (tile) colliders
  --  then, we'll loop through all (entity) collider offsets, using them to make new colliders
  --  if there are any collisions, then we'll set the flag on the entity
  for _, tile_collider in pairs(self.tile_colliders) do
    if collides(tile_collider, entity) then
      entity.collisions.center = true
      local tile_x = tile_collider.position.x
      local tile_y = tile_collider.position.y
      local x = snap_to_grid(entity.position.x)
      local y = snap_to_grid(entity.position.y)
      if tile_x > x then
        entity.collisions.right = true
      elseif tile_x <= x then
        entity.collisions.left = true
      end
      if tile_x == x and
         tile_y > y + 1 then
        entity.collisions.down = true
      end
    end
  end
end

return CollisionDetectionSystem
