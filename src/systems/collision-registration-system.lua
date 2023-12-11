local CollisionRegistrationSystem = tiny.processingSystem()
CollisionRegistrationSystem.filter = tiny.requireAny("hitbox")

function CollisionRegistrationSystem:init(props)
	self.bump_world = props.bump_world
end

function CollisionRegistrationSystem:onAdd(e)
	self.bump_world:add(e, e.position.x, e.position.y, e.hitbox.width, e.hitbox.height)
	e.bump_world = self.bump_world
end

function CollisionRegistrationSystem:onRemove(e)
	self.bump_world:remove(e)
end

return CollisionRegistrationSystem
