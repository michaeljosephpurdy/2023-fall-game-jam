local SolidTile = class("SolidTile")

function SolidTile:init(props)
	local width = props.width or 16
	local height = props.height or 16
	self.position = Vector.new(props.x, props.y)
	self.velocity = Vector.new(0, 0)
	self.hitbox = {
		width = width,
		height = height,
	}
	self.is_solid = true
	self.level_id = props.level_id
end

return SolidTile
