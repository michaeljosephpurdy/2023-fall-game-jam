local Player = class("Player")

function Player:init(props)
	self.old_level_id = nil
	self.level_id = nil
	self.position = Vector.new(props.x, props.y)
	self.spawn_point = self.position:clone()
	self.velocity = Vector.new(0, 0)
	self.direction = Vector.new(0, 0)
	self.width = 4
	self.height = 8
	self.deaths = 0

	self.is_player = true

	self.drawable = true
	self.controllable = true
	self.camera_follow = false

	self.max_jumps = 1
	self.max_gravity = 5
	self.gravity = self.max_gravity
	self.acceleration = 10
	self.top_speed = 100
	self.jump_force = 265
	self.coyote_time = 0.2
	self.coyote_timer = self.coyote_time
	self.top_fall_speed = 1
	self.friction = 0.95

	self.dash_force = 400
	self.dash_time = 0.5

	self.color = { 1, 0, 1, 1 }
	self.hitbox = { width = 4, height = 8 }
	self.platforming = true
	self.can_collide = true
end

function Player:on_collide() end

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

function Player:respawn()
	if self.position == self.spawn_point then
		return
	end
	self.deaths = self.deaths + 1
	self.velocity = Vector.new(0, 0)
	self.position = self.spawn_point:clone()
	self.old_position = self.position
	self.bump_world:update(self, self.spawn_point.x, self.spawn_point.y)
end

function Player:draw()
	-- self:tune_field("gravity", "1")
	-- self:tune_field("acceleration", "2")
	-- self:tune_field("top_speed", "3")
	-- self:tune_field("jump_force", "4")
	love.graphics.setColor(WHITE_COLOR)
	love.graphics.rectangle(
		"fill",
		self.position.x - self.width / 2,
		self.position.y - self.height,
		self.width * 2,
		self.height * 2
	)
end

return Player
