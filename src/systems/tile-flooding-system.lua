local TileFloodingSystem = tiny.processingSystem()

function TileFloodingSystem:init(props)
	self.fixed_tiles = {}
	self.tiles = {}
	PubSub.subscribe("ldtk.tile.create", function(t)
		if t.value == "1" then
			if not self.tiles[t.y] then
				self.tiles[t.y] = {}
			end
			self.tiles[t.y][t.x] = t.value
		end
	end)
	PubSub.subscribe("ldtk.done", function()
		self:fix_tiles()
	end)
end

function TileFloodingSystem:fix_tiles()
	-- we need to try to 'fix' all the tiles
	-- because it's really hurting performance having
	-- thousands of 16x16 tiles for collision checking
	-- when we could, in theory, have much less if we
	-- make them larger than 16x16
	for y, col in pairs(self.tiles) do
		for x, tile in pairs(col) do
			while col[x + 1] do
			end
		end
	end
end

return TileFloodingSystem
