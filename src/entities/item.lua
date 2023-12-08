local Item = class("Item")

function Item:init(props)
	self.drawable = true
	self.position = Vector.new(props.x, props.y)
	self.velocity = Vector.new(0, 0)
	self.hitbox = { width = props.width, height = props.width }
	self.type = props.customFields.type
	if self.type == "Double_jump" then
		self.text = "dbl jmp"
	end
	-- pass
end

function Item:on_collision(player)
	if self.is_done then
		return
	end
	self.is_done = true
	if self.type == "Double_jump" then
		player.double_jump = true
		player.max_jumps = player.max_jumps + 1
	end
end

function Item:draw()
	love.graphics.rectangle("fill", self.position.x, self.position.y, 8, 8)
	-- pass
end

return Item
