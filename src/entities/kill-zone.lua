local KillZone = class("KillZone")

function KillZone:init(props)
	self.position = Vector.new(props.x, props.y)
	self.velocity = Vector.new(0, 0)
	self.hitbox = { width = props.width, height = props.height }
	self.is_kill_zone = true
end

function KillZone:on_collision(player)
	player:respawn()
end

return KillZone
