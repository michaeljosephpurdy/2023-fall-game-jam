local GameData = class("GameData")

function GameData:init(props)
	self.is_game_data = true
	self.has_met_maker = false
	self.milliseconds = 0
	self.seconds = 0
	self.minutes = 0
	self.deaths = 0
end

function GameData:update_time(dt)
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
	love.graphics.print(string.format("%s:%s", self.minutes, self.seconds), 0, 0)
	love.graphics.print(self.deaths, 0, 10)
end

return GameData
