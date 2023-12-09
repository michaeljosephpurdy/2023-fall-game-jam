local EntitySpawningSystem = tiny.processingSystem()

local SolidTile = require("src.entities.solid-tile")
local Player = require("src.entities.player")
local NarratorTrigger = require("src.entities.narrator-trigger")
local KillZone = require("src.entities.kill-zone")
local Item = require("src.entities.item")
local SpawnPoint = require("src.entities.spawn-point")

function EntitySpawningSystem:init()
	local spritesheet = love.graphics.newImage("data/spritesheet.png")
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
		props.spritesheet = spritesheet
		if props.id == "Player" then
			local player_entity = Player:new(props)
			world:addEntity(player_entity)
		elseif props.id == "Narrator" then
			local narrator_trigger_entity = NarratorTrigger:new(props)
			world:addEntity(narrator_trigger_entity)
		elseif props.id == "KillZone" then
			local kill_zone_entity = KillZone:new(props)
			world:addEntity(kill_zone_entity)
		elseif props.id == "Item" then
			local item_entity = Item:new(props)
			world:addEntity(item_entity)
		elseif props.id == "SpawnPoint" then
			local spawn_point_entity = SpawnPoint:new(props)
			world:addEntity(spawn_point_entity)
		end
	end)
end

return EntitySpawningSystem
