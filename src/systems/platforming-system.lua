local PlatformingSystem = tiny.processingSystem()
PlatformingSystem.filter = tiny.requireAll('platforming')

function PlatformingSystem:process(e, dt)
    local platforming = e.platforming
    if platforming.moving then
        e.pos.x = e.pos.x + e.speed * platforming.direction * dt
        if platforming.direction == 1 then
	    --flip right
	else
	    --flip left
        end
    end
    if not e.on_ground then
        e.pos.y = e.pos.y + e.gravity * dt
    end
end

return PlatformingSystem
