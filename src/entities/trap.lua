local Arrow = require("src.entities.arrow-trap")
local Trap = class("Trap")

function Trap:init(props)
	local custom_fields = props.customFields

	self.iid = props.iid
	-- self.linked_entity_iid = custom_fields.Entity_ref.entityIid
	self.drawable_foreground = true
	self.is_trap = true

	self.type = custom_fields.trap
	self.position = { x = props.x, y = props.y }
	self.velocity = { x = 0, y = 0 }
	self.direction = { x = custom_fields.direction_x, y = custom_fields.direction_y }
	self.hitbox = { width = props.width, height = custom_fields.height * 16 }
	self.height = custom_fields.height
	self.spritesheet = props.spritesheet
	if self.type == "Arrow" then
		self.img = love.graphics.newQuad(8 * 16, 16, 16, 16, self.spritesheet)
	elseif self.type == "FallingDoor" then
		self.img = love.graphics.newQuad(10 * 16, 16, 16, 16, self.spritesheet)
		self.is_solid = true
		self.platforming = true
		self.collision_actor = true
		self.gravity = 0.3
		self.is_moving_door = true
	end
end

function Trap:trip()
	if self.type == "Arrow" then
		local arrow = Arrow:new({
			position = self.position,
			direction = self.direction,
			spritesheet = self.spritesheet,
		})
		self.world:addEntity(arrow)
		self.tripped = true
	elseif self.type == "FallingDoor" then
		self.velocity.y = -100
	end
end

function Trap:draw(dt)
	for i = 0, self.height - 1 do
		love.graphics.draw(self.spritesheet, self.img, self.position.x, self.position.y + i * 16)
	end
end

return Trap
