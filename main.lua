tiny = require("plugins.tiny-ecs")
require("plugins.table-additions")
require("plugins.30log")
PubSub = require("plugins.pubsub")
ldtk = require("plugins.super-simple-ldtk")
bump = require("plugins.bump")

SIXTY_FPS = 1 / 60
THIRTY_FPS = 1 / 30
GAME_WIDTH, GAME_HEIGHT = 256, 256

-- load all systems and register them to the world
-- we need to ensure they are registered in a specific order
-- so let's define them in that order here
local SYSTEMS_IN_ORDER = {
	require("src.systems.player-controller-system"),
	require("src.systems.platforming-system"),
	require("src.systems.collision-registration-system"),
	require("src.systems.collision-detection-system"),
	require("src.systems.trap-triggering-system"),
	require("src.systems.entity-spawning-system"),
	require("src.systems.level-transition-system"),
	require("src.systems.game-data-system"),
	require("src.systems.camera-system"),
	require("src.systems.tilemap-system"),
	require("src.systems.entity-background-drawing-system"),
	require("src.systems.entity-drawing-system"),
	require("src.systems.entity-foreground-drawing-system"),
	require("src.systems.narrator-drawing-system"),
	require("src.systems.audio-system"),
}

UPDATE_SYSTEMS = function(_, s)
	return not s.is_draw_system
end
DRAW_SYSTEMS = function(_, s)
	return s.is_draw_system
end

BLACK_COLOR = { 35 / 255, 38 / 255, 53 / 255 }
WHITE_COLOR = { 167 / 255, 172 / 255, 167 / 255 }

function love.load(arg)
	love.graphics.setDefaultFilter("nearest", "nearest")

	PubSub.subscribe("keypress", function(k)
		if k ~= "escape" then
			return
		end
		love.event.quit()
	end)
	world = tiny.world()
	local bump_world = bump.newWorld(64)

	for _, system in ipairs(SYSTEMS_IN_ORDER) do
		if system.init then
			system:init({
				bump_world = bump_world,
			})
		end
		world:addSystem(system)
	end

	ldtk:init("world")
	ldtk:load_all()
	-- ldtk:load("6b437db0-8990-11ee-8cf0-2d05cb81e2c1")
	-- tiny.refresh(world)
	accumulator = 0
end

function love.update(dt)
	accumulator = accumulator + dt
	while accumulator >= SIXTY_FPS do
		world:update(SIXTY_FPS, UPDATE_SYSTEMS)
		accumulator = accumulator - SIXTY_FPS
	end
end

function love.draw()
	local dt = love.timer.getDelta()
	world:update(dt, DRAW_SYSTEMS)
	-- love.graphics.print(love.timer.getFPS(), 0, 0)
	--max_collection = math.max((max_collection or 0), collectgarbage("count"))
	-- love.graphics.print(tostring(max_collection), 50, 80)
	-- love.graphics.print(tostring(collectgarbage("count")), 50, 50)
end

function love.keypressed(k)
	PubSub.publish("keypress", k)
end

function love.keyreleased(k)
	PubSub.publish("keyrelease", k)
end

function love.resize(w, h)
	PubSub.publish("love.resize", { w, h })
end
