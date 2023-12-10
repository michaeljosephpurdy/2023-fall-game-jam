local SpawnPoint = class("SpawnPoint")

function SpawnPoint:init(props)
	self.position = { x = props.x, y = props.y }
	self.velocity = { x = 0, y = 0 }
	self.hitbox = { width = props.width, height = props.height }
	self.drawable = true
end

function SpawnPoint:on_collision(player)
	player.spawn_point.x = self.position.x
	player.spawn_point.y = self.position.y
end

function SpawnPoint:draw()
	love.graphics.rectangle("line", self.position.x, self.position.y - 16, self.hitbox.width, self.hitbox.height)
end

return SpawnPoint
