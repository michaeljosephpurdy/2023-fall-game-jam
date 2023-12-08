local GameDataSystem = tiny.processingSystem()
GameDataSystem.filter = tiny.requireAny("is_player")

function GameDataSystem:onAddToWorld(world)
	self.game_data_entity = require("src.entities.game-data"):new()
	world:addEntity(self.game_data_entity)
end

function GameDataSystem:process(e, dt)
	self.game_data_entity.has_met_maker = e.has_met_maker
	self.game_data_entity.deaths = e.deaths
	self.game_data_entity:update_time(dt)
	love.graphics.push()
	love.graphics.origin()
	self.game_data_entity:draw()
	love.graphics.pop()
end

return GameDataSystem
