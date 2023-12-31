local Sfx = require("src.entities.sfx")
local Bg = require("src.entities.background-music")

local AudioSystem = tiny.processingSystem()
AudioSystem.filter = tiny.requireAll("is_audio")

AudioSystem.SOUNDS = {
	hit = love.audio.newSource("data/audio/HIT.wav", "static"),
	shoot = love.audio.newSource("data/audio/SHOOT.wav", "static"),
	jump = love.audio.newSource("data/audio/JUMP.wav", "static"),
	dash = love.audio.newSource("data/audio/DASH.wav", "static"),
	chest = love.audio.newSource("data/audio/OPEN_CHEST.wav", "static"),
	shrine = love.audio.newSource("data/audio/SHRINE.wav", "static"),
	death = love.audio.newSource("data/audio/DEATH.wav", "static"),
}

function AudioSystem:init(props)
	PubSub.subscribe("sfx.play", function(name)
		local sfx = Sfx:new({ source = self.SOUNDS[name] })
		self.world:addEntity(sfx)
	end)
end

function AudioSystem:onAddToWorld(world)
	local bg = Bg:new({ source = love.audio.newSource("data/audio/BACKGROUND.wav", "stream") })
	world:addEntity(bg)
end

function AudioSystem:process(e, dt)
	e:play()
	if e.one_shot then
		self.world:removeEntity(e)
	else
	end
end

return AudioSystem
