local CollisionSystem = tiny.processingSystem()
CollisionSystem.filter = tiny.requireAll("hitbox")

function CollisionSystem:init()
	self.bump_world = bump.newWorld(16)
end

function CollisionSystem:onAddToWorld(world) end

local function collision_filter(e1, e2)
	if e1.is_player then
		if e2.is_tile_map then
			e1.level_id = e2.level_id
			e2.should_draw = true
			return nil
		end
		if e2.is_solid then
			return "slide"
		end
	end
	return nil
end

function CollisionSystem:process(e, dt)
	local gravity = e.gravity or 0
	if e.velocity.y > 0 then
		gravity = gravity * e.friction
	end
	e.velocity.y = e.velocity.y + gravity * dt
	local cols, len
	local future_position = e.position + e.velocity * dt
	e.position.x, e.position.y, cols, len =
		self.bump_world:move(e, future_position.x, future_position.y, collision_filter)
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
	end
end

function CollisionSystem:onAdd(e)
	self.bump_world:add(e, e.position.x, e.position.y, e.hitbox.width, e.hitbox.height)
end

function CollisionSystem:onRemove(e)
	self.bump_world:remove(e)
end

return CollisionSystem
