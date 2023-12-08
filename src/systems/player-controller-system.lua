local PlayerControllerSystem = tiny.processingSystem()
PlayerControllerSystem.filter = tiny.requireAll("controllable")

function PlayerControllerSystem:init()
	self.released = { space = true }
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
	if love.keyboard.isDown("space") and self.released.space then
		e.jump_requested = true
		self.released.space = false
	end
end

return PlayerControllerSystem
