local EntityDrawingSystem = tiny.processingSystem()
EntityDrawingSystem.filter = tiny.requireAll('drawable', 'draw')

function EntityDrawingSystem:onAddToWorld(world)
end

function EntityDrawingSystem:preProcess(dt)
  --if not _G.camera then return end
end

function EntityDrawingSystem:process(e, dt)
  -- _G.camera:draw(function()
    -- e:draw()
  -- end)
  e:draw()
end

function EntityDrawingSystem:postProcess(dt)
  love.graphics.setColor(1, 1, 1, 1)
end

return EntityDrawingSystem
