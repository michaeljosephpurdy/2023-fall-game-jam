local Arrow = class("Arrow")

function Arrow:init(props)
	self.is_arrow = true

	self.collision_actor = true
	self.platforming = true
	self.drawable = true

	self.spritesheet = props.spritesheet
	self.position = { x = props.position.x, y = props.position.y + 6 }
	self.direction = { x = props.direction.x, y = props.position.y }
	self.velocity = { x = 160, y = 0 }
	self.hitbox = { width = 16, height = 4 }
	self.friction = 1

	self.img = love.graphics.newQuad(9 * 16, 16, 16, 16, self.spritesheet)
	PubSub.publish("sfx.play", "shoot")
end

function Arrow:on_collision(entity)
	if self.velocity.x == 0 then
		return
	end
	if entity.other and entity.other.respawn then
		entity.other:respawn()
	end
	if entity.respawn then
		entity:respawn()
	end
end

function Arrow:draw(dt)
	love.graphics.draw(self.spritesheet, self.img, self.position.x, self.position.y - 6)
end

return Arrow
