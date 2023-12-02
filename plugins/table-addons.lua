table.for_each = function(t, fn)
  for _, item in pairs(t) do
    fn(item)
  end
end

table.print = function(t)
  for k, v in pairs(t) do
    print(k .. ': ' .. tostring(v))
  end
end

table.map = function(t, fn)
  local new_table = {}
  table.for_each(t, function(item)
    local result = fn(item)
    if (result) then
      table.insert(new_table, result)
    end
  end)
  return new_table
end

table.filter = function(t, fn)
  local new_table = {}
  table.for_each(t, function(item)
    if fn(item) == true then
      table.insert(new_table, item)
    end
  end)
  return new_table
end
