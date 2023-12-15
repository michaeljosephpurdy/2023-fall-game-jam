local Sfx = class("Sfx")

function Sfx:init(props)
	self.is_audio = true
	self.one_shot = true
	self.source = props.source
	self.source:setVolume(0.25)
end

function Sfx:play()
	love.audio.play(self.source)
end

return Sfx
