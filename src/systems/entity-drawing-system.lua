local EntityDrawingSystem = tiny.processingSystem()
EntityDrawingSystem.filter = tiny.requireAll("drawable", "draw")
EntityDrawingSystem.is_draw_system = true

function EntityDrawingSystem:process(e, dt)
	e:draw(dt)
end

return EntityDrawingSystem
