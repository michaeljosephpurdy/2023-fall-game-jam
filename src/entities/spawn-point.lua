local SpawnPoint = class("SpawnPoint")

function SpawnPoint:init(props)
	self.position = Vector.new(props.x, props.y)
	self.velocity = Vector.new(0, 0)
	self.hitbox = { width = props.width, height = props.height }
	self.drawable = true
end

function SpawnPoint:on_collision(player)
	player.spawn_point = self.position
end

function SpawnPoint:draw()
	love.graphics.rectangle("line", self.position.x, self.position.y - 16, self.hitbox.width, self.hitbox.height)
end

return SpawnPoint
