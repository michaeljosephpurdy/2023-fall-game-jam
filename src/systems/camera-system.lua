local CameraSystem = tiny.processingSystem()
CameraSystem.filter = tiny.requireAll("camera_follow")

function lerp(a, b, t)
	return a + (b - a) * t
end

local function clamp(low, n, high)
	return math.min(math.max(n, low), high)
end

function CameraSystem:init()
	self.levels = {}
	self.focal_point = 0
	self.push = require("plugins.push")
	self.position = Vector.new(0, 0)
	self.old_position = Vector.new(0, 0)
	self.offset_position = Vector.new(-GAME_WIDTH / 2, -GAME_HEIGHT / 2)
	local windowWidth, windowHeight = 512, 512
	self.push:setupScreen(GAME_WIDTH, GAME_HEIGHT, windowWidth, windowHeight, { fullscreen = false, resizable = true })
	PubSub.subscribe("ldtk.level.load", function(level)
		self.levels[level.level_id] = {
			left_boundary = level.x,
			right_boundary = level.xx,
			top_boundary = level.y,
			bot_boundary = level.yy,
			width = level.width,
			height = level.height,
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
	local level = self.levels[e.level_id]
	self.old_position = self.position
	self.position = e.position + self.offset_position
	local camera_offset = e.direction.x * 50
	self.position.x = self.position.x + camera_offset
	if e.position.x + camera_offset >= level.right_boundary - GAME_WIDTH / 2 then
		self.position.x = level.right_boundary - GAME_WIDTH
	elseif e.position.x + camera_offset <= level.left_boundary + GAME_WIDTH / 2 then
		self.position.x = level.left_boundary
	end
	self.position.x = lerp(self.old_position.x, self.position.x, 5 * dt)
	if e.position.y >= level.bot_boundary - GAME_HEIGHT / 2 then
		self.position.y = level.bot_boundary - GAME_HEIGHT
	elseif e.position.y <= level.top_boundary + GAME_HEIGHT / 2 then
		self.position.y = level.top_boundary
	end
	self.position.y = lerp(self.old_position.y, self.position.y, 25 * dt)
	love.graphics.translate(-self.position.x, -self.position.y)
	-- crazy logging to help build camera, keeping this in for now...
	-- local y = e.position.y - GAME_HEIGHT / 2
	-- local x = e.position.x - GAME_WIDTH / 2
	-- love.graphics.print("left_boundary:" .. level.left_boundary, x, y)
	-- love.graphics.print("right_boundary:" .. level.right_boundary, x, y + 10)
	-- love.graphics.print("top_boundary:" .. level.top_boundary, x, y + 20)
	-- love.graphics.print("bot_boundary:" .. level.bot_boundary, x, y + 30)
	-- love.graphics.print("e.position:" .. tostring(e.position), x, y + 40)
	-- love.graphics.print("self.position:" .. tostring(self.position), x, y + 50)
end

return CameraSystem
