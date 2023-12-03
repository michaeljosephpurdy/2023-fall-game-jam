local CollisionSystem = tiny.processingSystem()
CollisionSystem.filter = tiny.requireAll('platforming')

local function collide(a, b)
  return a.x + a.width >= b.x and
         a.x <= b.x + b.width and
         a.y + a.height >= b.y and
         a.y <= b.y + b.height
end

function CollisionSystem:init()
  self.colliders = {}
  PubSub.subscribe('ldtk.level.load', function()
    self.colliders = {}
  end)
  PubSub.subscribe('ldtk.collider.create', function(collider)
    table.insert(self.colliders, collider)
  end)
end

function CollisionSystem:process(e, dt)
  for _, collider in pairs(self.colliders) do
    love.graphics.setColor(1, 1, 1, 1)
    if (collide(collider, e)) then
      love.graphics.setColor(1, 0, 0, 1)
    end
    love.graphics.rectangle('line', collider.x, collider.y, collider.width, collider.height)
  end
end

return CollisionSystem
