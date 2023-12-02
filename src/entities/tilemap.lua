local TileMap = class('TileMap')

-- not so much an actual tilemap
-- going to see how far we can get by just blitting the entire background of each level_path
-- while handling collisions based on actual tiles

function TileMap:init(props)
  self.image = love.graphics.newImage(props.image)
end

function TileMap:draw_tilemap()
  love.graphics.draw(self.image)
end

return TileMap
