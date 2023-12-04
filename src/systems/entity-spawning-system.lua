local EntitySpawningSystem = tiny.processingSystem()

local SolidTile = require('src.entities.solid-tile')
local Player = require('src.entities.player')

function EntitySpawningSystem:init()
  PubSub.subscribe('ldtk.image.create', function(img)
    local props = { image = img }
    local tilemap = require('src.entities.tilemap'):new(props)
    world:addEntity(tilemap)
  end)
  PubSub.subscribe('ldtk.tile.create', function(t)
    if t.value == '1' then
      local solid_tile = SolidTile:new(t)
      world:addEntity(solid_tile)
    end
  end)
  PubSub.subscribe('ldtk.entity.create', function(e)
    local props = { x = e.x, y = e.y }
    if e.id == 'Player' then
      local player_entity = Player:new(props)
      world:addEntity(player_entity)
    end
  end)
  print('initialized')
end

return EntitySpawningSystem
