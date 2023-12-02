local BackgroundDrawingSystem = tiny.system(class, 'BackgroundDrawingSystem')

function BackgroundDrawingSystem:init(props)
end

-- process only gets called when filter is successful?
function BackgroundDrawingSystem:process(dt)
end

-- update is always called?
function BackgroundDrawingSystem:update(dt)
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
end

return BackgroundDrawingSystem
