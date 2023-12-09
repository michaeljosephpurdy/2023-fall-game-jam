local Trap = class("Trap")

local Arrow = class("Arrow")
function Arrow:init(props)
	self.spritesheet = props.spritesheet
	self.position = props.position:clone()
	self.direction = props.direction:clone()
	self.velocity = Vector.new(40, 0)
	self.friction = 1
	self.position.y = self.position.y + 8
	self.hitbox = { width = 16, height = 4 }
	self.platforming = true
	self.drawable = true
	self.img = love.graphics.newQuad(9 * 16, 16, 16, 16, self.spritesheet)
end
function Arrow:draw(dt)
	love.graphics.draw(self.spritesheet, self.img, self.position.x, self.position.y)
end
function Arrow:on_collision(player)
	player:respawn()
end

function Trap:init(props)
	local custom_fields = props.customFields

	self.iid = props.iid
	self.linked_entity_iid = custom_fields.Entity_ref.entityIid
	self.drawable_foreground = true
	self.is_trap = true

	self.type = custom_fields.trap
	self.linked_entity = custom_fields.Entity_ref.entityIid
	self.position = Vector.new(props.x, props.y)
	self.velocity = Vector.new(0, 0)
	self.direction = Vector.new(custom_fields.direction_x, custom_fields.direction_y)
	self.hitbox = { width = props.width, height = props.height }

	self.spritesheet = props.spritesheet
	self.img = love.graphics.newQuad(8 * 16, 16, 16, 16, self.spritesheet)
end

function Trap:trip()
	if self.type == "Arrow" then
		local arrow = Arrow:new({
			position = self.position,
			direction = self.direction,
			spritesheet = self.spritesheet,
		})
		self.world:addEntity(arrow)
	end
	self.tripped = true
end

function Trap:draw(dt)
	if self.tripped then
		love.graphics.print("tripped!", self.position.x, self.position.y)
	end
	love.graphics.draw(self.spritesheet, self.img, self.position.x, self.position.y)
end

return Trap
