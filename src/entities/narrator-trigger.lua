local NarratorTrigger = class("NarratorTrigger")

function NarratorTrigger:init(props)
	if props.customFields then
		for k, v in pairs(props.customFields) do
			self[k] = v
		end
		if props.customFields["text2"] then
			self.text = props.customFields["text2"]
		end
	end
	self.is_narrator_trigger = true
	self.position = Vector.new(props.x, props.y)
	self.velocity = Vector.new(0, 0)
	self.hitbox = { width = props.width, height = props.height }
	self.triggered = false
	self.progress = 1
	self.never_triggered = false
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
	-- check if player has satisfied conditions to display this narration
	if self.conditions then
		for _, condition in ipairs(self.conditions) do
			-- if they haven't then just ignore the collision event
			if not e[condition] then
				return
			end
		end
	end
	self.triggered = true
	if self.on_fulfilled then
		for _, property in ipairs(self.on_fulfilled) do
			e[property] = true
		end
	end
end

function NarratorTrigger:draw()
	love.graphics.setColor(1, 1, 1)
	love.graphics.rectangle("fill", 5, 5, GAME_WIDTH - 10, 50)
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("fill", 10, 10, GAME_WIDTH - 20, 40)
	love.graphics.setColor(1, 1, 1)
	love.graphics.print(self.current_text, 15, 15)
	-- pass
end

return NarratorTrigger
