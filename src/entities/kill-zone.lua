local KillZone = class("KillZone")

function KillZone:init(props)
	self.position = Vector.new(props.x, props.y)
	self.velocity = Vector.new(0, 0)
	self.hitbox = { width = props.width, height = props.height }
	self.is_kill_zone = true
	if props.customFields then
		for k, v in pairs(props.customFields) do
			self[k] = v
		end
	end
end

function KillZone:on_collision(player)
	player:respawn()
	if self.on_fulfilled then
		for _, property in ipairs(self.on_fulfilled) do
			player[property] = true
		end
	end
end

return KillZone
