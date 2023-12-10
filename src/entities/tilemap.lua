local TileMap = class("TileMap")

-- not so much an actual tilemap
-- going to see how far we can get by just blitting the entire background of each level_path
-- while handling collisions based on actual tiles

function TileMap:init(props)
	self.image = love.graphics.newImage(props.image)
	self.position = { x = props.x, y = props.y }
	self.width, self.height = self.image:getDimensions()
	self.hitbox = { width = self.width, height = self.height }
	self.velocity = { x = 0, y = 0 }
	self.level_id = props.level_id

	self.is_tile_map = true
	self.should_draw = false
end

function TileMap:on_collision(player)
	if player.level_id == self.level_id then
		return
	end
	player.old_level_id = player.level_id
	player.level_id = self.level_id
end

function TileMap:draw_tilemap()
	--if not self.should_draw then
	-- return
	-- end
	-- love.graphics
	love.graphics.draw(self.image, self.position.x, self.position.y)
	self.should_draw = false
end

return TileMap
