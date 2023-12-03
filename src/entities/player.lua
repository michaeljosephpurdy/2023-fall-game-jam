local Player = class('Player')

function Player:init(props)
  self.position = Vector.new(props.x, props.y)
  self.velocity = Vector.new(0, 0)
  self.direction = Vector.new(0, 0)
  self.speed = 200
  self.width = 4
  self.height = 8
  self.controllable = true
  self.camera_follow = false
  self.direction = 0
  self.falling = true
  self.jump_force = 20
  self.drawable = true
  self.color = { 1, 0, 1, 1 }
  self.grounded = true
  self.gravity = 40
  self.platforming = true
  self.can_collide = true
  self.collider_offsets = {
    left =  Vector.new(-2, self.height / 3),
    right = Vector.new(self.width, self.height / 3),
    up =    Vector.new(0, 0),
    down =  Vector.new(self.width / 3, self.height)
  }
end

function Player:offset_colliders(dx, dy)
  -- for _, colliders in pairs(self.colliders) do
    -- colliders.x = colliders.x + dx
    -- colliders.x = colliders.x + dy
  -- end
end

local function draw_collider(col)
  love.graphics.rectangle('line', col.position.x, col.position.y, col.width, col.height)
end

function Player:draw()
  love.graphics.setColor(1, 0, 1, 1)
  love.graphics.rectangle('fill', self.position.x, self.position.y, self.width, self.height)
    for _, offset in pairs(self.collider_offsets) do
      local collider = {
        position = self.position + offset,
        width = 2,
        height = 2
      }
      draw_collider(collider)
    end
end

return Player
