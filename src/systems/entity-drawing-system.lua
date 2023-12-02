local EntityDrawingSystem = tiny.processingSystem()
EntityDrawingSystem.filter = tiny.requireAll('drawable')

function EntityDrawingSystem:preProcess(dt)
end

function EntityDrawingSystem:process(e, dt)
  if e.draw then
    e:draw()
  end
end

function EntityDrawingSystem:postProcess(dt)
end

return EntityDrawingSystem
