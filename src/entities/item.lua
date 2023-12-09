local Item = class("Item")

function Item:init(props)
	self.drawable_background = true
	self.position = Vector.new(props.x, props.y)
	self.velocity = Vector.new(0, 0)
	self.hitbox = { width = props.width, height = props.width }
	self.type = props.customFields.type
	self.spritesheet = props.spritesheet
	self.closed_img = love.graphics.newQuad(6 * 16, 0, 16, 16, self.spritesheet)
	self.open_image = love.graphics.newQuad(7 * 16, 0, 16, 16, self.spritesheet)
end

function Item:on_collision(player)
	if self.is_done then
		return
	end
	self.is_done = true
	if self.type == "Double_jump" then
		player.double_jump = true
		player.max_jumps = player.max_jumps + 1
	elseif self.type == "Dash" then
		player.can_dash = true
	end
end

function Item:draw()
	if self.is_done then
		love.graphics.draw(self.spritesheet, self.open_image, self.position.x, self.position.y)
		return
	end
	love.graphics.draw(self.spritesheet, self.closed_img, self.position.x, self.position.y)
	-- pass
end

return Item
