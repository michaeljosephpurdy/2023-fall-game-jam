local NarratorDrawingSystem = tiny.processingSystem()
NarratorDrawingSystem.filter = tiny.requireAll("is_narrator_trigger")

function NarratorDrawingSystem:init(props)
	self.draw_world = props.draw_world
	self.update_world = props.update_world
end

function NarratorDrawingSystem:process(e, dt)
	if not e.triggered then
		return
	end
	if e.is_done then
		self.draw_world:removeEntity(e)
		self.update_world:removeEntity(e)
	end
	e:update(dt)
	love.graphics.push()
	love.graphics.origin()
	e:draw()
	love.graphics.pop()
end

return NarratorDrawingSystem
