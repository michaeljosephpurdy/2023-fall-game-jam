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
    elseif e.grounded then
        e.pos.x = e.pos.x * 0.9
    end
end

return PlatformingSystem
