local CollisionSystem = tiny.processingSystem()
CollisionSystem.filter = tiny.requireAll('hitbox')

function CollisionSystem:init()
    PubSub.subscribe('ldtk.level.load', function(level)
      self.bump_world = bump.newWorld(level.tile_size)
    end)
end

function CollisionSystem:onAddToWorld(world)
end

local one_way_prefix = 'o'
one_way_prefix = one_way_prefix:byte(1)
local function collision_filter(e1, e2)
    if e1.is_player then
        if e2.is_bullet then return nil end
        if e2.is_enemy then return 'cross' end
    elseif e1.is_enemy then
        if e2.is_bullet then return nil end
        if e2.is_enemy then return nil end
        if e2.is_player then return 'cross' end
    elseif e1.is_bullet then
        if e2.is_player or e2.is_bullet then return nil end
    end
    if e1.is_solid then
        if type(e2) == 'string' then -- tile collision
            if e2:byte(1) == one_way_prefix then -- one way tile
                if e1.is_bullet then
                    return 'onewayplatformTouch'
                else
                    return 'onewayplatform'
                end
            else
                return 'slide'
            end
        elseif e2.is_solid then
            return 'slide'
        elseif e2.is_bouncy then
            return 'bounce'
        else
            return 'cross'
        end
    end
    return nil
end

function CollisionSystem:process(e, dt)
    local position = e.position
    local velocity = e.velocity
    local gravity = e.gravity or 0
    velocity.y = velocity.y + gravity * dt
    local cols, len
    position.x, position.y, cols, len = self.bump_world:move(e, position.x + velocity.x * dt, position.y + velocity.y * dt, collision_filter)
    e.on_ground = false
    for i = 1, len do
        local col = cols[i]
        local collided = true
        if col.type == 'touch' then
            velocity.x, velocity.y = 0, 0
        elseif col.type == 'slide' then
            if col.normal.x == 0 then
                velocity.y = 0
                if col.normal.y < 0 then
                    e.on_ground = true
                end
            else
                velocity.x = 0
            end
        elseif col.type == 'onewayplatform' then
            if col.did_touch then
                velocity.y = 0
                e.on_ground = true
            else
                collided = false
            end
        elseif col.type == 'onewayplatformTouch' then
            if col.did_touch then
                velocity.y = 0
                e.on_ground = true
            else
                collided = false
            end
        elseif col.type == 'bounce' then
            if col.normal.x == 0 then
                velocity.y = -velocity.y
                e.on_ground = true
            else
                velocity.x = -velocity.x
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
