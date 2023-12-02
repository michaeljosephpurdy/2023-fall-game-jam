tiny = require('plugins.tiny-ecs')
require('plugins.table-additions')
require('plugins.30log')
PubSub = require('plugins.pubsub')
ldtk = require('plugins.super-simple-ldtk')

function love.load()
  PubSub.subscribe('keypress', function(k)
    if k ~= 'escape' then return end
    love.event.quit()
  end)
  ldtk:init('world', on_entity_create)
  world = tiny.world(
    require('src.systems.player-controller-system'),
    require('src.systems.platforming-system'),
    require('src.systems.entity-drawing-system')
  )
  function on_entity_create(e)
    print('on_entity_create')
    print(e)
    local props = { x = e.x, y = e.y }
    if e.id == 'Player' then
      print('player found')
      local player_entity = require('src.entities.player'):new(props)
      world:add(player_entity)
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


