local SolidTile = class("SolidTile")

function SolidTile:init(props)
	local width = props.width or 16
	local height = props.height or 16
	self.position = { x = props.x, y = props.y }
	self.velocity = { x = 0, y = 0 }
	self.hitbox = {
		width = width,
		height = height,
	}
	self.is_solid = true
	self.level_id = props.level_id
end

return SolidTile
