local EntitySpawningSystem = tiny.processingSystem()

local Player = require("src.entities.player")
local NarratorTrigger = require("src.entities.narrator-trigger")
local KillZone = require("src.entities.kill-zone")
local Item = require("src.entities.item")
local SpawnPoint = require("src.entities.spawn-point")
local Trap = require("src.entities.trap")
local TrapTrigger = require("src.entities.trap-trigger")

function EntitySpawningSystem:init()
	local spritesheet = love.graphics.newImage("data/spritesheet.png")
	PubSub.subscribe("ldtk.image.create", function(props)
		local tilemap = require("src.entities.tilemap"):new(props)
		self.world:addEntity(tilemap)
	end)
	PubSub.subscribe("ldtk.entity.create", function(props)
		props.spritesheet = spritesheet
		local entity = nil
		if props.id == "Player" then
			entity = Player:new(props)
		elseif props.id == "Narrator" then
			entity = NarratorTrigger:new(props)
		elseif props.id == "KillZone" then
			entity = KillZone:new(props)
		elseif props.id == "Item" then
			entity = Item:new(props)
		elseif props.id == "SpawnPoint" then
			entity = SpawnPoint:new(props)
		elseif props.id == "TrapTrigger" then
			entity = TrapTrigger:new(props)
		elseif props.id == "Trap" then
			entity = Trap:new(props)
		end
		self.world:addEntity(entity)
		entity.world = self.world
	end)
end

return EntitySpawningSystem
