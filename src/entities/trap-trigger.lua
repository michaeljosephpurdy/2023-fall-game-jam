local TrapTrigger = class("TrapTrigger")

function TrapTrigger:init(props)
	local custom_fields = props.customFields

	self.is_trap_trigger = true
	self.is_triggered = false

	self.iid = props.iid
	self.linked_entity_iid = custom_fields.Entity_ref.entityIid
	self.drawable_foreground = true

	self.position = Vector.new(props.x, props.y)
	self.velocity = Vector.new(0, 0)
	self.hitbox = { width = props.width, height = props.height }

	self.spritesheet = props.spritesheet
	self.idle_img = love.graphics.newQuad(6 * 16, 16, 16, 16, self.spritesheet)
	self.triggered_img = love.graphics.newQuad(7 * 16, 16, 16, 16, self.spritesheet)
end

function TrapTrigger:draw(dt)
	if self.is_triggered then
		love.graphics.draw(self.spritesheet, self.triggered_img, self.position.x, self.position.y)
		return
	end
	love.graphics.draw(self.spritesheet, self.idle_img, self.position.x, self.position.y)
end

function TrapTrigger:on_collision(player)
	self.is_triggered = true
end

return TrapTrigger
