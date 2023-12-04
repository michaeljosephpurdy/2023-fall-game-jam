local Player = class('Player')

function Player:init(props)
  self.position = Vector.new(props.x, props.y)
  self.velocity = Vector.new(0, 0)
  self.direction = Vector.new(0, 0)
  self.is_player = true
  self.speed = 1000
  self.width = 4
  self.height = 8
  self.acceleration = 4
  self.controllable = true
  self.camera_follow = false
  self.direction = 0
  self.falling = true
  self.jump_force = 20
  self.drawable = true
  self.color = { 1, 0, 1, 1 }
  self.grounded = true
  self.gravity = 40
  self.hitbox = { width = 4, height = 4 }
  self.top_fall_speed = 1
  self.platforming = true
  self.can_collide = true
  self.collider_offsets = {
    left =  Vector.new(-2, self.height / 3),
    right = Vector.new(self.width, self.height / 3),
    up =    Vector.new(0, 0),
    down =  Vector.new(self.width / 3, self.height)
  }
end

function Player:on_collide()
  assert(nil)
end

function Player:draw()
  love.graphics.setColor(1, 0, 1, 1)
  love.graphics.rectangle('fill', self.position.x, self.position.y, self.width, self.height)
end

return Player
