local EntityDrawingSystem = tiny.processingSystem()
EntityDrawingSystem.is_draw_system = true
EntityDrawingSystem.filter = tiny.requireAll("drawable", "draw")

function EntityDrawingSystem:process(e, dt)
	e:draw()
end

return EntityDrawingSystem
