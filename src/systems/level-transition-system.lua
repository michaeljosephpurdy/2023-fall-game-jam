local LevelTransitionSystem = tiny.processingSystem()
LevelTransitionSystem.filter = tiny.requireAll("is_player")

function LevelTransitionSystem:init()
	self.levels = {}
	self.active_level = nil
	PubSub.subscribe("ldtk.level.load", function(level)
		table.insert(self.levels, level)
	end)
end

local function is_entity_in_level(level, e)
	local ex, ey = e.position.x, e.position.y
	return ex >= level.x and ex <= level.xx and ey >= level.y and ey <= level.yy
end

function LevelTransitionSystem:process(e, dt)
	for _, level in pairs(self.levels) do
		if level.level_id ~= e.level_id and is_entity_in_level(level, e) then
			e.level_id = level.level_id
			PubSub.publish("level.activated", level.level_id)
		end
	end
end

return LevelTransitionSystem
