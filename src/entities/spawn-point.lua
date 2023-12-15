local SpawnPointFx = require("src.entities.spawn-point-fx")
local SpawnPoint = class("SpawnPoint")

function SpawnPoint:init(props)
	self.position = { x = props.x, y = props.y }
	self.velocity = { x = 0, y = 0 }
	self.hitbox = { width = props.width, height = props.height }
	self.drawable_background = true
	self.spritesheet = props.spritesheet
	self.idle_img = love.graphics.newQuad(13 * 16, 0, 16, 16, self.spritesheet)
	self.active_img = love.graphics.newQuad(14 * 16, 0, 16, 16, self.spritesheet)
	PubSub.publish("spawnpoint.spawned")
end

function SpawnPoint:on_collision(entity)
	if not entity.is_player then
		return
	end
	if not self.active then
		self.active = true
		PubSub.publish("spawnpoint.activated")
		PubSub.publish("sfx.play", "shrine")
		local fx = SpawnPointFx:new({
			x = self.position.x + self.hitbox.width / 2,
			y = self.position.y + self.hitbox.height / 2,
		})
		self.world:addEntity(fx)
		fx.world = self.world
	end
	entity.spawn_point.x = self.position.x
	entity.spawn_point.y = self.position.y
end

function SpawnPoint:draw()
	if self.active then
		love.graphics.draw(self.spritesheet, self.active_img, self.position.x, self.position.y)
		return
	end
	love.graphics.draw(self.spritesheet, self.idle_img, self.position.x, self.position.y)
end

return SpawnPoint
