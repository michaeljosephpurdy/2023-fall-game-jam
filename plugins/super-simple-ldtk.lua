json = require("plugins.json")
csv = require("plugins.csv")

local FILE_NAMES = {
	SOLID_COLLIDERS = "SolidColliders.csv",
	DATA = "data.json",
}
local SuperSimpleLdtk = {}

local function load_and_parse_csv(file)
	local content = love.filesystem.read("string", file)
	return csv.openstring(content)
end

local function load_and_parse_json(file)
	local content = love.filesystem.read("string", file)
	return json.decode(content)
end

local current_folder = (...):gsub("%.[^%.]+$", "")

function SuperSimpleLdtk:init(world)
	self.path = string.format("data/%s/simplified", world)
	self.level_data = {}
	local level_files = love.filesystem.getDirectoryItems(self.path)
	print(level_files)
	for _, level_name in pairs(level_files) do
		local level_path = string.format("%s/%s/", self.path, level_name)
		local level_data_file = string.format("%s/%s", level_path, FILE_NAMES.DATA)
		local data = load_and_parse_json(level_data_file)
		data.path = level_path
		self.level_data[data.uniqueIdentifer] = data
	end
	PubSub.publish("ldtk.done")
end

function SuperSimpleLdtk:load_all()
	for _, level in pairs(self.level_data) do
		self:load(level.uniqueIdentifer)
		print("loaded " .. level.uniqueIdentifer)
	end
end

function SuperSimpleLdtk:load(level_id)
	local data = self.level_data[level_id]
	local level_path = data.path
	local level = {
		x = data.x,
		y = data.y,
		xx = data.x + data.width,
		yy = data.y + data.height,
		width = data.width,
		height = data.height,
		tile_size = 16,
		id = data.uniqueIdentifer,
		level_id = level_id,
		neighbors = {},
	}
	for _, neighbor in pairs(data.neighbourLevels) do
		table.insert(level.neighbors, neighbor.levelIid)
	end
	PubSub.publish("ldtk.level.load", level)
	for _, types in pairs(data.entities) do
		for _, entity in pairs(types) do
			entity.level_id = level_id
			entity.x = data.x + entity.x
			entity.y = data.y + entity.y
			PubSub.publish("ldtk.entity.create", entity)
		end
	end
	for _, layer in pairs(data.layers) do
		if layer:find(".png") then
			PubSub.publish("ldtk.image.create", {
				image = string.format("%s/%s", level_path, layer),
				x = data.x,
				y = data.y,
				level_id = data.uniqueIdentifer,
			})
		end
	end

	local collider_grid_file = string.format("%s/%s", level_path, FILE_NAMES.SOLID_COLLIDERS)
	local collider_grid = love.filesystem.read("string", collider_grid_file)
	local y = 0
	for rows in collider_grid:gmatch("[^\r\n]+") do
		local x = 0
		for cell in rows:gmatch("[^,]+") do
			PubSub.publish("ldtk.tile.create", {
				x = data.x + (x * 16),
				y = data.y + (y * 16),
				width = 16,
				height = 16,
				value = cell,
				level_id = level_id,
			})
			x = x + 1
		end
		y = y + 1
	end
end

return SuperSimpleLdtk
