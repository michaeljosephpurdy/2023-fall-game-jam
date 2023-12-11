local EntityBackgroundDrawingSystem = tiny.processingSystem()
EntityBackgroundDrawingSystem.filter = tiny.requireAll("drawable_background", "draw")
EntityBackgroundDrawingSystem.is_draw_system = true

function EntityBackgroundDrawingSystem:process(e, dt)
	e:draw(dt)
end

return EntityBackgroundDrawingSystem
