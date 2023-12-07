local EntitySpawningSystem = tiny.processingSystem()

local SolidTile = require("src.entities.solid-tile")
local Player = require("src.entities.player")
local NarratorTrigger = require("src.entities.narrator-trigger")

function EntitySpawningSystem:init()
	PubSub.subscribe("ldtk.image.create", function(props)
		local tilemap = require("src.entities.tilemap"):new(props)
		world:addEntity(tilemap)
	end)
	PubSub.subscribe("ldtk.tile.create", function(t)
		if t.value == "1" then
			local solid_tile = SolidTile:new(t)
			world:addEntity(solid_tile)
		end
	end)
	PubSub.subscribe("ldtk.entity.create", function(props)
		if props.id == "Player" then
			local player_entity = Player:new(props)
			world:addEntity(player_entity)
		elseif props.id == "Narrator" then
			local narrator_trigger_entity = NarratorTrigger:new(props)
			world:addEntity(narrator_trigger_entity)
		end
	end)
end

return EntitySpawningSystem
