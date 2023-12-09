local EntityForegroundDrawingSystem = tiny.processingSystem()
EntityForegroundDrawingSystem.filter = tiny.requireAll("drawable_foreground", "draw")

function EntityForegroundDrawingSystem:onAddToWorld(world) end

function EntityForegroundDrawingSystem:preProcess(dt) end

function EntityForegroundDrawingSystem:process(e, dt)
	e:draw()
end

function EntityForegroundDrawingSystem:postProcess(dt) end

return EntityForegroundDrawingSystem
