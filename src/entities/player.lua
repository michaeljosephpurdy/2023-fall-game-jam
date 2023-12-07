local Player = class("Player")

function Player:init(props)
	-- self.level_id = props.level_id

	self.position = Vector.new(props.x, props.y)
	self.velocity = Vector.new(0, 0)
	self.direction = Vector.new(0, 0)
	self.width = 4
	self.height = 8

	self.is_player = true

	self.drawable = true
	self.controllable = true
	self.camera_follow = false

	self.gravity = 5
	self.acceleration = 10
	self.top_speed = 100
	self.jump_force = 265
	self.coyote_time = 0.2
	self.coyote_timer = self.coyote_time
	self.top_fall_speed = 1
	self.friction = 0.95

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

function Player:tune_field(field_name, button)
	love.graphics.print(field_name .. self[field_name], self.position.x, self.position.y + 8 * tonumber(button))
	if not love.keyboard.isDown(button) then
		return
	end
	if love.keyboard.isDown("down") then
		self[field_name] = self[field_name] - 5
	end
	if love.keyboard.isDown("up") then
		self[field_name] = self[field_name] + 5
	end
end

function Player:draw()
	-- self:tune_field("gravity", "1")
	-- self:tune_field("acceleration", "2")
	-- self:tune_field("top_speed", "3")
	-- self:tune_field("jump_force", "4")
	love.graphics.setColor(1, 0, 1, 1)
	love.graphics.rectangle(
		"fill",
		self.position.x - self.width / 2,
		self.position.y - self.height,
		self.width * 2,
		self.height * 2
	)
end

return Player
