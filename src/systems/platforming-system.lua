local PlatformingSystem = tiny.processingSystem()
PlatformingSystem.filter = tiny.requireAll("platforming")

function PlatformingSystem:onAddToWorld(world) end

function PlatformingSystem:process(e, dt)
	local friction = e.friction or 0.95
	if e.on_ground then
		e.jumps = e.max_jumps
		e.coyote_timer = e.coyote_time
	else
		e.coyote_timer = e.coyote_timer - dt
	end
	if e.moving then
		if e.direction.x == 1 then
			e.velocity.x = math.min(e.top_speed, e.velocity.x + e.acceleration)
		else
			e.velocity.x = math.max(-e.top_speed, e.velocity.x - e.acceleration)
		end
	elseif e.on_ground then
		if e.velocity.x > 0 then
			e.velocity.x = math.max(0, (e.velocity.x - friction))
		elseif e.velocity.x < 0 then
			e.velocity.x = math.min(0, (e.velocity.x + friction))
		end
	end
	e.velocity.x = e.velocity.x * friction
	-- single jump
	if e.jump_requested and e.jumps >= 1 and (e.on_ground or e.coyote_timer > 0) then
		e.jumps = e.jumps - 1
		e.velocity.y = -e.jump_force
		e.on_ground = false
	elseif e.jump_requested and e.jumps >= 1 and e.max_jumps == 2 then
		e.jumps = e.jumps - 1
		if e.coyote_timer <= 0 then
			e.jumps = e.jumps - 1
		end
		e.velocity.y = -e.jump_force
		e.on_ground = false
	end
end

return PlatformingSystem
