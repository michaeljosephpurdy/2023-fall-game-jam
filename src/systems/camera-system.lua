local CameraSystem = tiny.processingSystem()
CameraSystem.filter = tiny.requireAll('camera_follow')

local function clamp(low, n, high)
  return math.min(math.max(n, low), high)
end

local function round(i)
  return math.floor(i * 16 + 8)/32
end

function CameraSystem:onAddToWorld(world)
  self.left_boundary = 0
  self.right_boundary = GAME_WIDTH
  self.top_boundary = 0
  self.bot_boundary = GAME_HEIGHT
  --gamera = require('plugins.gamera')
  self.push = require('plugins.push')
  local windowWidth, windowHeight = 512, 512
  self.push:setupScreen(GAME_WIDTH, GAME_HEIGHT, windowWidth, windowHeight, { fullscreen = false, resizable = true })
  PubSub.subscribe('love.resize', function(data)
    self.push:resize(data[1], data[2])
    --_G.camera = gamera.new(0, 0, self.push:toReal(GAME_WIDTH, GAME_HEIGHT))
  end)
  PubSub.subscribe('level.load', function(level)
    self.left_boundary = level.x
    self.right_boundary = level.xx
    self.top_boundary = level.y
    self.bot_boundary = level.yy
    --_G.camera = gamera.new(level.x, level.y, level.xx, level.yy)
  end)
end

function CameraSystem:preWrap(dt)
  self.push:start()
end

function CameraSystem:postWrap(dt)
  self.push:finish()
end

function CameraSystem:onAdd(e)
end

function CameraSystem:process(e, dt)
  self.x = clamp(self.left_boundary, pos.x, self.right_boundary)
  self.y = clamp(self.bot_boundary, pos.y, self.top_boundary)
  love.graphics.translate(self.x, self.y)
end

return CameraSystem
