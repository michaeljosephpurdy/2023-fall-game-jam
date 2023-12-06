local SolidTile = class("SolidTile")

function SolidTile:init(props)
	self.position = Vector.new(props.x, props.y)
	self.velocity = Vector.new(0, 0)
	self.hitbox = {
		width = props.width,
		height = props.height,
	}
	self.is_solid = true
	self.level_id = props.level_id
end

return SolidTile
