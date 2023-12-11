local EntityForegroundDrawingSystem = tiny.processingSystem()
EntityForegroundDrawingSystem.filter = tiny.requireAll("drawable_foreground", "draw")
EntityForegroundDrawingSystem.is_draw_system = true

function EntityForegroundDrawingSystem:process(e, dt)
	e:draw(dt)
end

return EntityForegroundDrawingSystem
