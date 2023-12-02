tiny = require('plugins.tiny-ecs')
require('plugins.table-additions')
require('plugins.30log')
PubSub = require('plugins.pubsub')
ldtk = require('plugins.super-simple-ldtk')

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')
  PubSub.subscribe('keypress', function(k)
    if k ~= 'escape' then return end
    love.event.quit()
  end)
  world = tiny.world()

  -- load all systems and register them to the world
  local systems = love.filesystem.getDirectoryItems('src/systems')
  for _, system in ipairs(systems) do
    local system_path = string.format('src.systems.%s', system)
    world:addSystem(require(system_path:gsub('.lua','')))
  end

  ldtk:init('world')
  ldtk.on_image_create = function(self, image)
    if not image:find('AutoLayer.png') then return end
    local props = { image = image }
    local background_image = require('src.entities.background-image'):new(props)
    world:addEntity(background_image)
  end
  -- all entities are loaded via LDtk, which will call on_entity_create
  ldtk.on_entity_create = function(self, e)
    local props = { x = e.x, y = e.y }
    if e.id == 'Player' then
      print('player found')
      local player_entity = require('src.entities.player'):new(props)
      world:addEntity(player_entity)
    end
  end
  ldtk:load(0)
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

