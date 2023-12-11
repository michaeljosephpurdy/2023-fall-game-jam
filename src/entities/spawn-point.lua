local SpawnPoint = class("SpawnPoint")

function SpawnPoint:init(props)
	self.position = { x = props.x, y = props.y }
	self.velocity = { x = 0, y = 0 }
	self.hitbox = { width = props.width, height = props.height }
	self.drawable_background = true
	self.spritesheet = props.spritesheet
	self.idle_img = love.graphics.newQuad(13 * 16, 0, 16, 16, self.spritesheet)
	self.active_img = love.graphics.newQuad(14 * 16, 0, 16, 16, self.spritesheet)
end

function SpawnPoint:on_collision(player)
	if not self.active then
		self.active = true
		PubSub.publish("spawnpoint.activated")
	end
	player.spawn_point.x = self.position.x
	player.spawn_point.y = self.position.y
end

function SpawnPoint:draw()
	if self.active then
		love.graphics.draw(self.spritesheet, self.active_img, self.position.x, self.position.y)
		return
	end
	love.graphics.draw(self.spritesheet, self.idle_img, self.position.x, self.position.y)
end

return SpawnPoint
