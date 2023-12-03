json = require('plugins.json')
csv = require('plugins.csv')

local SuperSimpleLdtk = {}

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
  -- first grab the data file to get:
  --   the location and dimensions of the level
  --   the entities in the level
  --   the layer image file names
  -- there is some other goodies in there, too:
  --   the neighboring levels
  --   the background color
  local data = load_and_parse_json(data_path)
  print('publishing ltdk.level.load')
  PubSub.publish('ldtk.level.load', {
    x = data.x,
    y = data.y,
    xx = data.x + data.width,
    yy = data.y + data.height,
  })
  for _, types in pairs(data.entities) do
    for _, entity in pairs(types) do
      PubSub.publish('ldtk.entity.create', entity)
    end
  end
  for _, layer in pairs(data.layers) do
    if layer:find('.png') then
      PubSub.publish('ldtk.image.create', string.format('%s/%s', level_path, layer))
    end
  end
  -- local files = love.filesystem.getDirectoryItems(level_path)
  -- for _, file in ipairs(files) do
    -- if file:find('.png') then
      -- PubSub.publish('ldtk.image.create', string.format('%s/%s', level_path, file))
    -- end
  -- end
end

return SuperSimpleLdtk
