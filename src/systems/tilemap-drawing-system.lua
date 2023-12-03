local TilemapDrawingSystem = tiny.processingSystem()

TilemapDrawingSystem.filter = tiny.requireAll('draw_tilemap')

function TilemapDrawingSystem:init()
  PubSub.subscribe('ldtk.level.load', function(level)
    self.debug_rect = { level.x, level.y, level.xx, level.yy }
  end)
end

function TilemapDrawingSystem:onAddToWorld(world)
  -- we need this to always be the first system
  tiny.setSystemIndex(world, self, 2)
end

function TilemapDrawingSystem:process(e, dt)
  e:draw_tilemap()
end

function TilemapDrawingSystem:postProcess(dt)
  if not self.debug_rect then return end
  local debug_rect = self.debug_rect
  love.graphics.rectangle('line', debug_rect[1], debug_rect[2], debug_rect[3], debug_rect[4])
end

return TilemapDrawingSystem
