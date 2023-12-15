local GameData = class("GameData")

function GameData:init(props)
	self.is_game_data = true
	self.position = { x = props.x, y = props.y }
	self.velocity = { x = 0, y = 0 }
	self.hitbox = { width = props.width, height = props.height }
	self.drawable_background = true
	self.has_met_maker = false
	self.milliseconds = 0
	self.seconds = 0
	self.minutes = 0
	self.deaths = 0
	self.total_spawn_points = 0
	self.spawn_points = 0
end

function GameData:on_collision(player)
	player.friction = 0
	player.moving = false
	self.is_done = true
end

function GameData:update_time(dt)
	if self.is_done then
		return
	end
	self.milliseconds = self.milliseconds + dt
	if self.milliseconds >= 1 then
		self.milliseconds = self.milliseconds - 1
		self.seconds = self.seconds + 1
	end
	if self.seconds >= 60 then
		self.seconds = self.seconds - 60
		self.minutes = self.minutes + 1
	end
end

function GameData:draw()
	local seconds = tostring(self.seconds)
	if #seconds < 2 then
		seconds = "0" .. tostring(seconds)
	end
	local x, y = self.position.x, self.position.y
	love.graphics.print("Thanks for playing:", x, y + 10)
	love.graphics.print('"the treasure is real, rare, and important"', x, y + 30)
	love.graphics.print(string.format("      time: %s:%s", self.minutes, seconds), x, y + 50)
	love.graphics.print(string.format("  deaths: %s", self.deaths), x, y + 70)
	love.graphics.print(string.format(" shrines: %s/%s", self.spawn_points, self.total_spawn_points), x, y + 70)
end

return GameData
