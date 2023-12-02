local TilemapDrawingSystem = tiny.processingSystem()

TilemapDrawingSystem.filter = tiny.requireAll('draw_tilemap')

function TilemapDrawingSystem:onAddToWorld(world)
  -- we need this to always be the first system
  tiny.setSystemIndex(world, self, -1)
end

function TilemapDrawingSystem:process(e, dt)
  e:draw_tilemap()
  -- _G.camera:draw(function()
   -- e:draw()
  -- end)
end

return TilemapDrawingSystem
