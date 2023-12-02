local CameraSystem = tiny.system()

function CameraSystem:onAddToWorld(world)
  self.push = require('plugins.push')
  local gameWidth, gameHeight = 256, 256
  local windowWidth, windowHeight = 512, 512
  self.push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, { fullscreen = false, resizable = true })
  PubSub.subscribe('love.resize', function(data)
    self.push:resize(data[1], data[2])
  end)
end

function CameraSystem:preWrap(dt)
  self.push:start()
end

function CameraSystem:postWrap(dt)
  self.push:finish()
end

return CameraSystem
