tiny = require("plugins.tiny-ecs")
require("plugins.table-additions")
require("plugins.vectors")
require("plugins.30log")
PubSub = require("plugins.pubsub")
ldtk = require("plugins.super-simple-ldtk")
bump = require("plugins.bump")

GAME_WIDTH, GAME_HEIGHT = 256, 256

-- load all systems and register them to the world
-- we need to ensure they are registered in a specific order
-- so let's define them in that order here
local SYSTEMS_IN_ORDER = {
	require("src.systems.camera-system"),
	require("src.systems.tilemap-system"),
	require("src.systems.player-controller-system"),
	require("src.systems.platforming-system"),
	require("src.systems.collision-system"),
	require("src.systems.entity-background-drawing-system"),
	require("src.systems.entity-drawing-system"),
	require("src.systems.entity-foreground-drawing-system"),
	require("src.systems.entity-spawning-system"),
	require("src.systems.level-transition-system"),
	require("src.systems.narrator-drawing-system"),
	require("src.systems.game-data-system"),
}

BLACK_COLOR = { 35 / 255, 38 / 255, 53 / 255 }
WHITE_COLOR = { 167 / 255, 172 / 255, 167 / 255 }

function love.load(arg)
	love.graphics.setDefaultFilter("nearest", "nearest")

	PubSub.subscribe("keypress", function(k)
		if k ~= "escape" and k ~= "q" then
			return
		end
		love.event.quit()
	end)
	world = tiny.world()

	local a = Vector.new(2, 2)
	for _, system in ipairs(SYSTEMS_IN_ORDER) do
		if system.init then
			system:init()
		end
		world:addSystem(system)
		system.world = world
	end

	ldtk:init("world")
	ldtk:load_all()
	-- ldtk:load("6b437db0-8990-11ee-8cf0-2d05cb81e2c1")
	-- tiny.refresh(world)
end

function love.draw()
	local dt = love.timer.getDelta()
	world:update(dt)
	-- love.graphics.print(string.format("FPS: %s", love.timer.getFPS()), 0, 20)
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
