json = require('plugins.json')
csv = require('plugins.csv')

local SuperSimpleLdtk = {
  __loaded_levels={}
}

local function load_and_parse_json(path)
  local content, error = love.filesystem.read('string', path)
  if error then
    print(string.format('%s error when reading %s', error, path))
  end
  return json.decode(content)
end

local current_folder = (...):gsub('%.[^%.]+$', '')

function SuperSimpleLdtk:init(world)
  self.path = string.format('data/%s/simplified', world)
  print(self.path)
end

function SuperSimpleLdtk:load(level)
  local level_path = string.format('%s/Level_%s', self.path, level)
  local data_path = string.format('%s/data.json', level_path)
  local data = load_and_parse_json(data_path)
  PubSub.publish('level.load', {
    x = data.x,
    y = data.y,
    xx = data.x + data.width,
    yy = data.y + data.height,
  })
  for _, types in pairs(data.entities) do
    for __, entity in pairs(types) do
      self:on_entity_create(entity)
    end
  end
  local files = love.filesystem.getDirectoryItems(level_path)
  for _, file in ipairs(files) do
    print(file)
    if file:find('.png') then
      self:on_image_create(string.format('%s/%s', level_path, file))
    end
  end
end

return SuperSimpleLdtk
