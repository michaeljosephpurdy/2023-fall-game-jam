local TilemapSystem = tiny.processingSystem()

TilemapSystem.filter = tiny.requireAll("draw_tilemap")

function TilemapSystem:init()
	PubSub.subscribe("ldtk.level.load", function(level)
		self.debug_rect = { level.x, level.y, level.xx, level.yy }
	end)
end

function TilemapSystem:process(e, dt)
	e:draw_tilemap()
end

return TilemapSystem
