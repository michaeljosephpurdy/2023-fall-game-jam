local PlayerControllerSystem = tiny.processingSystem()
PlayerControllerSystem.filter = tiny.requireAll("controllable")

function PlayerControllerSystem:init()
	self.released = { x = true, z = true }
	PubSub.subscribe("keyrelease", function(k)
		self.released[k] = true
	end)
end

function PlayerControllerSystem:process(e, dt)
	e.direction = Vector.new(0, 0)

	local left = love.keyboard.isDown("left")
	local right = love.keyboard.isDown("right")
	e.moving = left or right

	if right then
		e.direction.x = 1
	elseif left then
		e.direction.x = -1
	end

	e.jump_requested = false
	if love.keyboard.isDown("x") and self.released.x then
		e.jump_requested = true
		self.released.x = false
	end

	e.dash_requested = false
	if love.keyboard.isDown("z") and self.released.z then
		e.dash_requested = true
		self.released.z = false
	end
end

return PlayerControllerSystem
