local PlayerControllerSystem = tiny.processingSystem()
PlayerControllerSystem.filter = tiny.requireAll("controllable")

function PlayerControllerSystem:init()
	self.released = { x = true, z = true }
	PubSub.subscribe("keyrelease", function(k)
		self.released[k] = true
	end)
end

function PlayerControllerSystem:process(e, dt)
	if e.is_game_over then
		return
	end
	e.direction = { x = 0, y = 0 }

	local left = love.keyboard.isDown("left")
	local right = love.keyboard.isDown("right")
	e.moving = left or right

	if right then
		e.direction.x = 1
		e.flip_h = true
	elseif left then
		e.direction.x = -1
		e.flip_h = false
	end

	if love.keyboard.isDown("x") and self.released.x then
		e.jump_buffer = e.max_jump_buffer
		self.released.x = false
	end

	e.dash_requested = false
	if love.keyboard.isDown("z") and self.released.z then
		e.dash_requested = true
		self.released.z = false
	end
end

return PlayerControllerSystem
