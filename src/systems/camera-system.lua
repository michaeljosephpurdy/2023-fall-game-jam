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
			width = level.width,
			height = level.height,
		}
		print(level.level_id)
		print("x: " .. level.x)
		print("y: " .. level.y)
		print("xx: " .. level.xx)
		print("yy: " .. level.yy)
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
	self.position.x = e.position.x - GAME_WIDTH / 2
	if e.position.x + GAME_WIDTH / 2 >= level.right_boundary then
		self.position.x = level.right_boundary - GAME_WIDTH
	end
	if e.position.x - GAME_WIDTH / 2 <= level.left_boundary then
		self.position.x = level.left_boundary
	end
	love.graphics.translate(-self.position.x, 0)
	-- love.graphics.print("left_boundary:" .. level.left_boundary, e.position.x, 80)
	-- love.graphics.print("right_boundary:" .. level.right_boundary, e.position.x, 90)
	-- love.graphics.print("position:" .. e.position.x, e.position.x, 100)
	-- love.graphics.print("WIDTH:" .. GAME_WIDTH, e.position.x, 110)
end

return CameraSystem
