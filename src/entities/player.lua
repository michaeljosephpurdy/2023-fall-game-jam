local Player = class("Player")

function Player:init(props)
	PubSub.subscribe("keypress", function(k)
		if k == "1" then
			self.gravity = self.gravity + 1
		end
		if k == "2" then
			self.acceleration = self.acceleration + 1
		end
		if k == "3" then
			self.jump_force = self.jump_force + 1
		end
	end)

	self.position = Vector.new(props.x, props.y)
	self.velocity = Vector.new(0, 0)
	self.direction = Vector.new(0, 0)
	self.width = 4
	self.height = 8

	self.is_player = true

	self.drawable = true
	self.controllable = true
	self.camera_follow = false

	self.acceleration = 340
	self.top_speed = 800
	self.gravity = 200
	self.coyote_time = 0.2
	self.coyote_timer = self.coyote_time
	self.top_fall_speed = 1
	self.jump_force = 120

	self.falling = true
	self.color = { 1, 0, 1, 1 }
	self.grounded = true
	self.hitbox = { width = 4, height = 8 }
	self.platforming = true
	self.can_collide = true
end

function Player:on_collide()
	assert(nil)
end

function Player:draw()
	love.graphics.setColor(1, 0, 1, 1)
	love.graphics.rectangle("fill", self.position.x, self.position.y, self.width, self.height)
	love.graphics.print("gravity: " .. self.gravity, self.position.x, self.position.y + 8)
	love.graphics.print("acceleration: " .. self.acceleration, self.position.x, self.position.y + 16)
end

return Player
