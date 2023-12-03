tiny = require('plugins.tiny-ecs')
require('plugins.table-additions')
require('plugins.30log')
PubSub = require('plugins.pubsub')
ldtk = require('plugins.super-simple-ldtk')

GAME_WIDTH, GAME_HEIGHT = 250, 250

function love.load(arg)
  love.graphics.setDefaultFilter('nearest', 'nearest')

  PubSub.subscribe('keypress', function(k)
    if k ~= 'escape' and k ~= 'q' then return end
    love.event.quit()
  end)
  world = tiny.world()

  -- load all systems and register them to the world
  local system_modules = love.filesystem.getDirectoryItems('src/systems')
  for _, system_module in ipairs(system_modules) do
    local system_path = string.format('src.systems.%s', system_module)
    local system = require(system_path:gsub('.lua',''))
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
      print('player found')
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

