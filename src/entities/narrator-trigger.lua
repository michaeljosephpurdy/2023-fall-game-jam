local NarratorTrigger = class("NarratorTrigger")

function NarratorTrigger:init(props)
	if props.customFields and props.customFields.narrator_text then
		self.text = props.customFields.narrator_text[1]
		self.one_shot = props.customFields.one_shot
	end
	self.is_narrator_trigger = true
	self.position = Vector.new(props.x, props.y)
	self.velocity = Vector.new(0, 0)
	self.hitbox = { width = props.width, height = props.height }
	self.triggered = false
	self.progress = 1
	self.never_triggered = false
	self.timer = #self.text * 0.2
end

function NarratorTrigger:update(dt)
	self.progress = self.progress + 10 * dt
	if self.progress >= #self.text then
		self.progress = #self.text
		self.timer = self.timer - dt
		if self.one_shot and self.timer <= 0 then
			self.is_done = true
		end
	end
	self.current_text = string.sub(self.text, 1, math.floor(self.progress))
end

function NarratorTrigger:on_collision(e)
	self.triggered = true
	-- pass
end

function NarratorTrigger:draw()
	love.graphics.setColor(1, 1, 1)
	love.graphics.rectangle("fill", 5, 5, GAME_WIDTH - 10, 50)
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("fill", 10, 10, GAME_WIDTH - 20, 40)
	love.graphics.setColor(1, 1, 1)
	love.graphics.print(self.current_text, 20, 20)
	-- pass
end

return NarratorTrigger
