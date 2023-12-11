local EntityForegroundDrawingSystem = tiny.processingSystem()
EntityForegroundDrawingSystem.is_draw_system = true
EntityForegroundDrawingSystem.filter = tiny.requireAll("drawable_foreground", "draw")

function EntityForegroundDrawingSystem:onAddToWorld(world) end

function EntityForegroundDrawingSystem:preProcess(dt) end

function EntityForegroundDrawingSystem:process(e, dt)
	e:draw(dt)
end

function EntityForegroundDrawingSystem:postProcess(dt) end

return EntityForegroundDrawingSystem
