local Player = class('Player')

function Player:init(props)
    self.x = props.x
    self.y = props.y
    self.speed = 200
    self.width = 4
    self.height = 8
    self.controllable = true
    self.camera_follow = false
    self.drawable = true
    self.color = { 1, 0, 1, 1 }
    self.grounded = true
    self.gravity = 10
    self.platforming = {
        moving = false
    }
end

function Player:draw()
    love.graphics.setColor(1, 0, 1, 1)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

return Player
