local Arrow = require("src.entities.arrow-trap")
local TrapTrigger = class("TrapTrigger")

function TrapTrigger:init(props)
	local custom_fields = props.customFields

	self.is_trap_trigger = true
	self.is_triggered = false

	self.iid = props.iid
	self.drawable_foreground = true

	self.linked_entity_iids = {}
	for _, entity in ipairs(custom_fields.entity_refs) do
		table.insert(self.linked_entity_iids, entity.entityIid)
	end
	self.one_time = custom_fields.one_time

	self.position = { x = props.x, y = props.y }
	self.velocity = { x = 0, y = 0 }
	self.hitbox = { width = props.width, height = props.height }

	self.spritesheet = props.spritesheet
	self.idle_img = love.graphics.newQuad(6 * 16, 16, 16, 16, self.spritesheet)
	self.triggered_img = love.graphics.newQuad(7 * 16, 16, 16, 16, self.spritesheet)
end

function TrapTrigger:draw(dt)
	if not self.is_triggered then
		love.graphics.draw(self.spritesheet, self.idle_img, self.position.x, self.position.y)
		return
	end
	love.graphics.draw(self.spritesheet, self.triggered_img, self.position.x, self.position.y)
	if not self.one_time then
		self.is_done = false
		self.is_triggered = false
	end
end

function TrapTrigger:on_collision(entity)
	if entity.is_player then
		self.is_triggered = true
	end
end

return TrapTrigger
