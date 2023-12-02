local BackgroundImageDrawingSystem = tiny.processingSystem()

BackgroundImageDrawingSystem.filter = tiny.requireAll('background_image')

function BackgroundImageDrawingSystem:onAddToWorld(world)
  -- we need this to always be the first system
  tiny.setSystemIndex(world, self, -1)
end

function BackgroundImageDrawingSystem:process(e, dt)
  e:draw()
end

return BackgroundImageDrawingSystem
