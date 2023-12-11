local PlatformingSystem = tiny.processingSystem()
PlatformingSystem.filter = tiny.requireAll("platforming")

function PlatformingSystem:onAddToWorld(world) end

function PlatformingSystem:process(e, dt)
	local top_speed = e.top_speed
	local gravity = e.gravity or 0
	local friction = e.friction or 0.95

	if e.dashing then
		-- dashing, we:
		--  * don't want any gravity to be applied when dashing
		--  * need to stop dashing after a period of time
		--  * give ourselves a higher top_speed
		e.gravity = 0
		e.dashing = e.dashing - dt
		top_speed = e.top_speed * 2
		if e.dashing < 0 then
			e.gravity = e.max_gravity
			-- e.velocity.y = e.old_velocity.y
			e.dashing = nil
		end
	end

	if e.on_ground then
		e.dashed = false
		e.jumps = e.max_jumps
		e.coyote_timer = e.coyote_time or 0
	else
		e.coyote_timer = (e.coyote_timer or 0) - dt
	end

	e.jump_buffer = (e.jump_buffer or 0) - dt
	if e.jump_buffer < 0 then
		e.jump_buffer = 0
	end

	if e.moving then
		if e.direction.x == 1 then
			e.velocity.x = math.min(top_speed, e.velocity.x + e.acceleration)
		else
			e.velocity.x = math.max(-top_speed, e.velocity.x - e.acceleration)
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
	if e.jump_buffer > 0 and e.jumps >= 1 and (e.on_ground or e.coyote_timer > 0) then
		e.jumps = e.jumps - 1
		e.velocity.y = -e.jump_force
		e.on_ground = false
	elseif e.jump_buffer > 0 and e.jumps >= 1 and e.max_jumps == 2 then
		e.jumps = e.jumps - 1
		if e.coyote_timer <= 0 then
			e.jumps = e.jumps - 1
		end
		e.velocity.y = -e.jump_force
		e.on_ground = false
	end

	if e.can_dash and e.dash_requested and not e.dashed then
		e.dashed = true
		e.old_velocity = { x = e.velocity.x, y = e.velocity.y }
		e.velocity.x = e.velocity.x + (e.direction.x * e.dash_force)
		e.velocity.y = 0
		e.dashing = e.dash_time
	end

	if e.velocity.y > 0 then
		gravity = gravity * friction
	end
	e.velocity.y = e.velocity.y + gravity
end

return PlatformingSystem
