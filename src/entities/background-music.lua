local Bg = class("BackgroundMusic")

function Bg:init(props)
	self.is_audio = true
	self.source = props.source
	self.source:setVolume(0.1)
	self.source:setLooping(true)
end

function Bg:play()
	if not self.source:isPlaying() then
		love.audio.play(self.source)
	end
end

return Bg
