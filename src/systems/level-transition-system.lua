local SolidTile = require("src.entities.solid-tile")

local LevelTransitionSystem = tiny.processingSystem()
LevelTransitionSystem.filter = tiny.requireAll("is_player")

function LevelTransitionSystem:init(props)
	self.update_world = props.update_world
	self.level_balancing_coroutine = coroutine.create(function() end)
	self.levels = {}
	self.tiles_by_level = {}
	self.neighbors_by_level = {}
	self.active_level = nil
	self.active_tiles = {}
	PubSub.subscribe("ldtk.level.load", function(level)
		table.insert(self.levels, level)
		if not self.neighbors_by_level[level.level_id] then
			self.neighbors_by_level[level.level_id] = {}
		end
		for _, neighbor in pairs(level.neighbors) do
			table.insert(self.neighbors_by_level[level.level_id], neighbor)
		end
	end)
	PubSub.subscribe("ldtk.tile.create", function(t)
		if t.value ~= "1" then
			return
		end
		local solid_tile = SolidTile:new(t)
		if not self.tiles_by_level[solid_tile.level_id] then
			self.tiles_by_level[solid_tile.level_id] = {}
		end
		table.insert(self.tiles_by_level[solid_tile.level_id], solid_tile)
	end)
end

function LevelTransitionSystem:process(player, dt)
	coroutine.resume(self.level_balancing_coroutine)
	if player.level_id == player.old_level_id then
		return
	end
	self.level_balancing_coroutine = coroutine.create(function()
		local old_entities = {}
		for _, entity in pairs(self.tiles_by_level[player.old_level_id] or {}) do
			table.insert(old_entities, entity)
		end
		for _, new_entity in pairs(self.tiles_by_level[player.level_id]) do
			self.update_world:addEntity(new_entity)
		end
		coroutine.yield()
		for _, old_entity in pairs(old_entities) do
			self.update_world:removeEntity(old_entity)
			coroutine.yield()
		end
	end)
	coroutine.resume(self.level_balancing_coroutine)
	player.old_level_id = player.level_id
end

return LevelTransitionSystem
