json = require('plugins.json')
csv = require('plugins.csv')

local SuperSimpleLdtk = {}

local function load_and_parse_csv(file)
  local content = love.filesystem.read('string', file)
  return csv.openstring(content)
end

local function load_and_parse_json(file)
  local content = love.filesystem.read('string', file)
  return json.decode(content)
end

local current_folder = (...):gsub('%.[^%.]+$', '')

function SuperSimpleLdtk:init(world)
  self.path = string.format('data/%s/simplified', world)
end

function SuperSimpleLdtk:load(level)
  local level_path = string.format('%s/Level_%s', self.path, level)
  -- first grab the data file to get:
  --   the location and dimensions of the level
  --   the entities in the level
  --   the layer image file names
  -- there is some other goodies in there, too:
  --   the neighboring levels
  --   the background color
  local data_file = string.format('%s/data.json', level_path)
  local data = load_and_parse_json(data_file)
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

  --
  local collider_grid_file = string.format('%s/IntGrid.csv', level_path)
  local collider_grid = love.filesystem.read('string', collider_grid_file)
  local y = 0
  for rows in collider_grid:gmatch('[^\r\n]+') do
    local x = 0
    for cell in rows:gmatch('[^,]+') do
      if cell == '1' then
        local collider = { x = x * 16, y = y *16, width = 16, height = 16 }
        PubSub.publish('ldtk.collider.create', collider)
      end
      x = x + 1
    end
    y = y + 1
  end
end

return SuperSimpleLdtk
