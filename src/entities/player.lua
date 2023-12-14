local Player = class("Player")

function Player:init(props)
	self.old_level_id = nil
	self.level_id = nil
	self.position = { x = props.x, y = props.y }
	self.spawn_point = { x = props.x, y = props.y }
	self.velocity = { x = 0, y = 0 }
	self.direction = { x = 0, y = 0 }
	self.width = 4
	self.height = 8
	self.deaths = 0

	self.collision_actor = true
	self.is_player = true

	self.drawable = true
	self.controllable = true
	self.camera_follow = false

	self.max_jump_buffer = 0.1
	self.jump_buffer = 0
	self.max_jumps = 1
	self.max_gravity = 8.5
	self.gravity = self.max_gravity
	self.acceleration = 7
	self.top_speed = 95.5
	self.jump_force = 254
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
	self.can_dash = false

	self.spritesheet = props.spritesheet
	self.sprite_rects = {
		IDLE = { { 0, 80, 32, 32 } },
		RUN = { { 32, 80, 32, 32 }, { 64, 80, 32, 32 }, { 96, 80, 32, 32 }, { 64, 80, 32, 32 }, { 32, 80, 32, 32 } },
		JUMP = { { 128, 80, 32, 32 } },
		DASH = { { 192, 80, 32, 36 } },
		FALL = { { 160, 80, 32, 32 } },
	}
	self.sprites = {}
	for state, rects in pairs(self.sprite_rects) do
		self.sprites[state] = {}
		print(state)
		for _, rect in pairs(rects) do
			local sprite = love.graphics.newQuad(rect[1], rect[2], rect[3], rect[4], self.spritesheet)
			table.insert(self.sprites[state], sprite)
		end
	end
end

function Player:on_collide() end

function Player:tune_field(field_name, button)
	love.graphics.print(field_name .. self[field_name], self.position.x, self.position.y + 8 * tonumber(button))
	if not love.keyboard.isDown(button) then
		return
	end
	if love.keyboard.isDown("down") then
		self[field_name] = self[field_name] - 0.5
	end
	if love.keyboard.isDown("up") then
		self[field_name] = self[field_name] + 0.5
	end
end

function Player:respawn()
	if self.position == self.spawn_point then
		return
	end
	PubSub.publish("player.respawn", 0)
	self.deaths = self.deaths + 1
	self.velocity = { x = 0, y = 0 }
	self.position = { x = self.spawn_point.x, y = self.spawn_point.y }
	self.old_position = { x = self.spawn_point.x, y = self.spawn_point.y }
	self.bump_world:update(self, self.spawn_point.x, self.spawn_point.y)
end

function Player:draw(dt)
	-- self:tune_field("gravity", "1")
	-- self:tune_field("acceleration", "2")
	-- self:tune_field("top_speed", "3")
	-- self:tune_field("jump_force", "4")
	-- running sprite
	self.old_draw_state = self.draw_state or "IDLE"
	local flip = 1
	local x_pos, y_pos = self.position.x - 16, self.position.y - 22
	if self.flip_h then
		flip = -1
		x_pos = x_pos + 32
	end
	if self.draw_state ~= self.old_draw_state then
		self.draw_frame = 1
	end
	if self.dashing then
		self.draw_state = "DASH"
		self.draw_frame = 1
		-- dashing
	elseif self.moving and self.velocity.y == 0 then
		-- running
		self.draw_state = "RUN"
		self.draw_frame = self.draw_frame + dt * 4.5
		if self.draw_frame > #self.sprites.RUN then
			self.draw_frame = 1
		end
	elseif self.velocity.y < 0 then
		-- jumping
		self.draw_state = "JUMP"
		self.draw_frame = 1
	elseif self.velocity.y > 0 then
		-- falling
		self.draw_state = "FALL"
		self.draw_frame = 1
	else
		-- idle
		self.draw_state = "IDLE"
		self.draw_frame = 1
	end
	love.graphics.draw(
		self.spritesheet,
		self.sprites[self.draw_state][math.floor(self.draw_frame)],
		x_pos,
		y_pos,
		0,
		flip,
		1
	)
end

return Player
