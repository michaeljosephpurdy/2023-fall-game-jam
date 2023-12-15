local SpawnPointFx = class("SpawnPointFx")

function SpawnPointFx:init(props)
	self.drawable_foreground = true
	self.position = { x = props.x, y = props.y }
	self.radius = 1
	self.speed = 150
end

function SpawnPointFx:draw(dt)
	if self.radius > 500 then
		self.world:removeEntity(self)
	end
	self.radius = self.radius + self.speed * dt
	love.graphics.setColor(WHITE_COLOR)
	love.graphics.circle("line", self.position.x, self.position.y, self.radius)
	love.graphics.setColor(WHITE_COLOR)
	love.graphics.circle("line", self.position.x, self.position.y, self.radius + 16)
end

return SpawnPointFx
