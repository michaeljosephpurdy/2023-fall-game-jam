local EntityBackgroundDrawingSystem = tiny.processingSystem()
EntityBackgroundDrawingSystem.is_draw_system = true
EntityBackgroundDrawingSystem.filter = tiny.requireAll("drawable_background", "draw")

function EntityBackgroundDrawingSystem:onAddToWorld(world) end

function EntityBackgroundDrawingSystem:preProcess(dt) end

function EntityBackgroundDrawingSystem:process(e, dt)
	e:draw()
end

function EntityBackgroundDrawingSystem:postProcess(dt) end

return EntityBackgroundDrawingSystem
