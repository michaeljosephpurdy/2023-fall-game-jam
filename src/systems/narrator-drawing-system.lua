local NarratorDrawingSystem = tiny.processingSystem()
NarratorDrawingSystem.is_draw_system = true
NarratorDrawingSystem.filter = tiny.requireAll("is_narrator_trigger")

function NarratorDrawingSystem:init(props) end

function NarratorDrawingSystem:process(e, dt)
	if not e.triggered then
		return
	end
	if e.is_done then
		self.world:removeEntity(e)
	end
	e:update(dt)
	love.graphics.push()
	love.graphics.origin()
	e:draw()
	love.graphics.pop()
end

return NarratorDrawingSystem
