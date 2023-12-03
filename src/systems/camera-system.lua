local CameraSystem = tiny.processingSystem()
CameraSystem.filter = tiny.requireAll('camera_follow')

local function clamp(low, n, high)
  return math.min(math.max(n, low), high)
end

function CameraSystem:init()
  self.push = require('plugins.push')
  self.offset = GAME_WIDTH * .33
  self.x, self.y = 0, 0
  local windowWidth, windowHeight = 512, 512
  self.push:setupScreen(GAME_WIDTH, GAME_HEIGHT, windowWidth, windowHeight, { fullscreen = false, resizable = true })
  self.calculate_boundaries = function(level)
    self.left_boundary = level.x
    self.right_boundary = level.xx
    self.top_boundary = level.y
    self.bot_boundary = level.yy
  end
  PubSub.subscribe('level.load', function(level)
    self:calculate_boundaries(level)
  end)
  PubSub.subscribe('love.resize', function(data)
    self.push:resize(data[1], data[2])
  end)
end

function CameraSystem:onAddToWorld(world)
  tiny.setSystemIndex(world, self, 1)
  self:calculate_boundaries({ x = 0, xx = GAME_WIDTH, y = 0, yy = GAME_HEIGHT })
end

function CameraSystem:preWrap(dt)
  self.push:start()
end

function CameraSystem:postWrap(dt)
  self.push:finish()
  love.graphics.print(self.x)
end

function CameraSystem:onAdd(e)
end

function CameraSystem:process(e, dt)
  self.x = e.pos.x - self.offset
  if e.pos.x <= self.left_boundary + self.offset then
    self.x = -self.left_boundary
  elseif self.x >= self.right_boundary then
    self.x = self.right_boundary + self.offset / 2
  end
  love.graphics.translate(-self.x, -self.y)
end

return CameraSystem
