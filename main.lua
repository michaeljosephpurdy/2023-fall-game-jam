tiny = require('plugins.tiny-ecs')
require('plugins.table-additions')
require('plugins.vectors')
require('plugins.30log')
PubSub = require('plugins.pubsub')
ldtk = require('plugins.super-simple-ldtk')

GAME_WIDTH, GAME_HEIGHT = 250, 250

-- load all systems and register them to the world
-- we need to ensure they are registered in a specific order
-- so let's define them in that order here
local SYSTEMS_IN_ORDER = {
  require('src.systems.camera-system'),
  require('src.systems.tilemap-drawing-system'),
  require('src.systems.player-controller-system'),
  require('src.systems.platforming-system'),
  require('src.systems.collision-detection-system'),
  require('src.systems.collision-resolution-system'),
  require('src.systems.entity-drawing-system'),
}

function love.load(arg)
  love.graphics.setDefaultFilter('nearest', 'nearest')

  PubSub.subscribe('keypress', function(k)
    if k ~= 'escape' and k ~= 'q' then return end
    love.event.quit()
  end)
  world = tiny.world()

  local a = Vector.new(2, 2)
  for _, system in ipairs(SYSTEMS_IN_ORDER) do
    if system.init then system:init() end
    world:addSystem(system)
  end

  ldtk:init('world')
  PubSub.subscribe('ldtk.image.create', function(img)
    local props = { image = img }
    local tilemap = require('src.entities.tilemap'):new(props)
    world:addEntity(tilemap)
  end)
  PubSub.subscribe('ldtk.entity.create', function(e)
    local props = { x = e.x, y = e.y }
    if e.id == 'Player' then
      local player_entity = require('src.entities.player'):new(props)
      world:addEntity(player_entity)
    end
  end)

  ldtk:load(0)
  tiny.refresh(world)
end

function love.update(dt)
end

function love.draw()
  local dt = love.timer.getDelta()
  world:update(dt)
  love.graphics.print(string.format('FPS: %s', love.timer.getFPS()), 0, 20)
end

function love.keypressed(k)
  PubSub.publish('keypress', k)
end

function love.keyreleased(k)
  PubSub.publish('keyrelease', k)
end

function love.resize(w, h)
  PubSub.publish('love.resize', { w, h })
end

