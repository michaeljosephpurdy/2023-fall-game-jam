local Player = class('Player')

function Player:init(props)
    print('player init')
    self.pos = { x = props.x, y = props.y }
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
    love.graphics.rectangle('fill', self.pos.x, self.pos.y, self.width, self.height)
end

return Player
