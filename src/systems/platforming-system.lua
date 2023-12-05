local PlatformingSystem = tiny.processingSystem()
PlatformingSystem.filter = tiny.requireAll("platforming")

function PlatformingSystem:onAddToWorld(world) end

function PlatformingSystem:process(e, dt)
	local friction = e.friction or 0.95
	if e.on_ground then
		e.jumped = false
		e.coyote_timer = e.coyote_time
	else
		e.coyote_timer = e.coyote_timer - dt
	end
	if e.moving then
		if e.direction.x == 1 then
			e.velocity.x = math.min(e.top_speed, e.velocity.x + e.acceleration * dt)
		else
			e.velocity.x = math.max(-e.top_speed, e.velocity.x - e.acceleration * dt)
		end
	elseif e.on_ground then
		if e.velocity.x > 0 then
			e.velocity.x = math.max(0, e.velocity.x - friction * dt)
		elseif e.velocity.x < 0 then
			e.velocity.x = math.min(0, e.velocity.x + friction * dt)
		end
	end
	e.velocity.x = e.velocity.x * friction
	if e.jump_requested and not e.jumped and (e.on_ground or e.coyote_timer > 0) then
		e.velocity.y = -e.jump_force
		e.on_ground = false
		e.jumped = true
	end
end

return PlatformingSystem
