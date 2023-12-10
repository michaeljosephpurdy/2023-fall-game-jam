tiny = require("plugins.tiny-ecs")
require("plugins.table-additions")
require("plugins.vectors")
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
local UPDATE_SYSTEMS_IN_ORDER = {
	require("src.systems.player-controller-system"),
	require("src.systems.platforming-system"),
	require("src.systems.collision-system"),
	require("src.systems.trap-triggering-system"),
	require("src.systems.entity-spawning-system"),
	require("src.systems.level-transition-system"),
	require("src.systems.game-data-system"),
}
local DRAW_SYSTEMS_IN_ORDER = {
	require("src.systems.camera-system"),
	require("src.systems.tilemap-system"),
	require("src.systems.entity-background-drawing-system"),
	require("src.systems.entity-drawing-system"),
	require("src.systems.entity-foreground-drawing-system"),
	require("src.systems.narrator-drawing-system"),
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
	update_world = tiny.world()
	draw_world = tiny.world()
	local bump_world = bump.newWorld(16)

	local a = Vector.new(2, 2)
	for _, system in ipairs(UPDATE_SYSTEMS_IN_ORDER) do
		if system.init then
			system:init({
				update_world = update_world,
				draw_world = draw_world,
				bump_world = bump_world,
			})
			system.update_world = update_world
			system.draw_world = draw_world
			system.bump_world = bump_world
		end
		update_world:addSystem(system)
	end
	for _, system in ipairs(DRAW_SYSTEMS_IN_ORDER) do
		if system.init then
			system:init({
				update_world = update_world,
				draw_world = draw_world,
			})
			system.update_world = update_world
			system.draw_world = draw_world
		end
		draw_world:addSystem(system)
	end

	ldtk:init("world")
	ldtk:load_all()
	-- ldtk:load("6b437db0-8990-11ee-8cf0-2d05cb81e2c1")
	-- tiny.refresh(world)
end

function love.update(dt)
	dt = math.min(dt, THIRTY_FPS)
	update_world:update(dt)
end

function love.draw()
	local dt = love.timer.getDelta()
	draw_world:update(dt)
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
