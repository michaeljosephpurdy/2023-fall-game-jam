local CameraSystem = tiny.processingSystem()
CameraSystem.filter = tiny.requireAll("camera_follow")

local function clamp(low, n, high)
	return math.min(math.max(n, low), high)
end

function CameraSystem:init()
	self.levels = {}
	self.push = require("plugins.push")
	self.offset = GAME_WIDTH * 0.33
	self.position = Vector.new(0, 0)
	local windowWidth, windowHeight = 512, 512
	self.push:setupScreen(GAME_WIDTH, GAME_HEIGHT, windowWidth, windowHeight, { fullscreen = false, resizable = true })
	PubSub.subscribe("ldtk.level.load", function(level)
		self.levels[level.level_id] = {
			left_boundary = level.x,
			right_boundary = level.xx,
			top_boundary = level.y,
			bot_boundary = level.yy,
		}
	end)
	PubSub.subscribe("love.resize", function(data)
		self.push:resize(data[1], data[2])
	end)
end

function CameraSystem:onAddToWorld(world) end

function CameraSystem:preWrap(dt)
	self.push:start()
end

function CameraSystem:postWrap(dt)
	self.push:finish()
end

function CameraSystem:onAdd(e) end

function CameraSystem:process(e, dt)
	if not e.level_id then
		return
	end
	local left_boundary = self.levels[e.level_id].left_boundary
	local right_boundary = self.levels[e.level_id].right_boundary
	self.position.x = e.position.x - self.offset
	if e.position.x <= left_boundary + self.offset then
		self.position.x = -left_boundary
	elseif self.position.x >= right_boundary + self.offset / 2 then
		self.position.x = right_boundary + self.offset / 2
	end
	love.graphics.translate(-self.position.x, -self.position.y)
end

return CameraSystem
