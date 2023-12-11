local CollisionDetectionSystem = tiny.processingSystem()
CollisionDetectionSystem.filter = tiny.requireAll("collision_actor")

function CollisionDetectionSystem:init(props)
	self.bump_world = props.bump_world
end

local function collision_filter(e1, e2)
	if e1.is_player then
		if e2.is_solid then
			return "slide"
		end
		return "cross"
	elseif e1.is_moving_door then
		if e2.is_solid then
			return "slide"
		end
	elseif e1.is_arrow then
		if e2.is_solid then
			return "touch"
		end
	end
	return nil
end

function CollisionDetectionSystem:process(e, dt)
	local cols, len
	local future_x = e.position.x + (e.velocity.x * dt)
	local future_y = e.position.y + (e.velocity.y * dt)
	e.position.x, e.position.y, cols, len = self.bump_world:move(e, future_x, future_y, collision_filter)
	e.on_ground = false
	for i = 1, len do
		local col = cols[i]
		local collided = true
		if col.type == "touch" then
			e.velocity.x, e.velocity.y = 0, 0
		elseif col.type == "slide" then
			if col.normal.x == 0 then
				e.velocity.y = 0
				if col.normal.y < 0 then
					e.on_ground = true
				end
			else
				e.velocity.x = 0
			end
		elseif col.type == "onewayplatform" then
			if col.did_touch then
				e.velocity.y = 0
				e.on_ground = true
			else
				collided = false
			end
		elseif col.type == "onewayplatformTouch" then
			if col.did_touch then
				e.velocity.y = 0
				e.on_ground = true
			else
				collided = false
			end
		elseif col.type == "bounce" then
			if col.normal.x == 0 then
				e.velocity.y = -e.velocity.y
				e.on_ground = true
			else
				e.velocity.x = -e.velocity.x
			end
		end

		if e.on_collision and collided then
			e:on_collision(col)
		end
		if col.other and col.other.on_collision and collided then
			col.other:on_collision(e)
		end
	end
end

return CollisionDetectionSystem
