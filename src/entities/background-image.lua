local BackgroundImage = class('BackgroundImage')

function BackgroundImage:init(props)
  self.background_image = love.graphics.newImage(props.image)
end

function BackgroundImage:draw()
  love.graphics.draw(self.background_image)
end

return BackgroundImage
