tiny = require('plugins.tiny-ecs')
require('plugins.table-additions')
require('plugins.30log')
PubSub = require('plugins.pubsub')

function love.load()
    PubSub.subscribe('keypress', function(k)
        if k ~= 'escape' then return end
        love.event.quit()
    end)
    player = require('src.entities.player'):new()
    world = tiny.world(
        require('src.systems.player-controller-system'),
        require('src.systems.platforming-system'),
        player
    )
    print(player)
end

function love.update(dt)
    world:update(dt)
end

function love.draw()
    player:draw()
end

function love.keypressed(k)
    PubSub.publish('keypress', k)
end

function love.keyreleased(k)
    PubSub.publish('keyrelease', k)
end


