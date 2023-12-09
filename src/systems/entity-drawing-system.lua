local EntityDrawingSystem = tiny.processingSystem()
EntityDrawingSystem.filter = tiny.requireAll("drawable", "draw")

function EntityDrawingSystem:onAddToWorld(world) end

function EntityDrawingSystem:preProcess(dt) end

function EntityDrawingSystem:process(e, dt)
	e:draw()
end

function EntityDrawingSystem:postProcess(dt) end

return EntityDrawingSystem
