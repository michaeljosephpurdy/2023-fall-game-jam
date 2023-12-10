local TrapTriggeringSystem = tiny.processingSystem()
TrapTriggeringSystem.filter = tiny.requireAny("is_trap_trigger", "is_trap")

function TrapTriggeringSystem:init(props)
	self.triggers = {}
	self.traps = {}
	self.update_world = props.update_world
	self.draw_world = props.draw_world
end

function TrapTriggeringSystem:onAdd(e)
	if e.is_trap_trigger then
		table.insert(self.triggers, e)
	end
	if e.is_trap then
		e.update_world = self.update_world
		e.draw_world = self.draw_world
		table.insert(self.traps, e)
	end
end

function TrapTriggeringSystem:process(e, dt)
	if e.is_done then
		return
	end
	if e.is_trap_trigger and e.is_triggered then
		for _, trap in pairs(self.traps) do
			if e.linked_entity_iid == trap.iid then
				trap:trip()
				e.is_done = true
			end
		end
	end
	if e.is_trap then
	end
	-- pass
end

return TrapTriggeringSystem
