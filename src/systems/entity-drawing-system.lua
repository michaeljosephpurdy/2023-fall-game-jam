local EntityDrawingSystem = tiny.processingSystem()
EntityDrawingSystem.filter = tiny.requireAll("drawable", "draw")

function EntityDrawingSystem:process(e, dt)
	e:draw()
end

return EntityDrawingSystem
