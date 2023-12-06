local TilemapSystem = tiny.processingSystem()

TilemapSystem.filter = tiny.requireAll("draw_tilemap")

function TilemapSystem:init()
	PubSub.subscribe("ldtk.level.load", function(level)
		self.debug_rect = { level.x, level.y, level.xx, level.yy }
	end)
end

function TilemapSystem:onAddToWorld(world)
	self.world = world
end

function TilemapSystem:process(e, dt)
	e:draw_tilemap()
end

function TilemapSystem:postProcess(dt)
	if not self.debug_rect then
		return
	end
	local debug_rect = self.debug_rect
	love.graphics.rectangle("line", debug_rect[1], debug_rect[2], debug_rect[3], debug_rect[4])
end

return TilemapSystem
