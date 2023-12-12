local GameDataSystem = tiny.processingSystem()
GameDataSystem.filter = tiny.requireAny("is_game_data")

function GameDataSystem:init(props)
	self.deaths = 0
	self.total_spawn_points = 0
	self.spawn_points = 0
	PubSub.subscribe("player.respawn", function(i)
		self.deaths = self.deaths + 1
	end)
	PubSub.subscribe("spawnpoint.spawned", function(i)
		self.total_spawn_points = self.total_spawn_points + 1
	end)
	PubSub.subscribe("spawnpoint.activated", function(i)
		self.spawn_points = self.spawn_points + 1
	end)
end

function GameDataSystem:onAdd(e)
	self.game_data_entity = e
end

function GameDataSystem:process(e, dt)
	e:update_time(dt)
	e.deaths = self.deaths
	e.total_spawn_points = self.total_spawn_points
	e.spawn_points = self.spawn_points
end

return GameDataSystem
