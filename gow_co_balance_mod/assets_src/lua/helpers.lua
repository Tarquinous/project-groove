local unpack = table.unpack or unpack

local helpers = {}

function helpers.deepcopy(orig)
  local orig_type = type(orig)
  local copy
  if orig_type == 'table' then
      copy = {}
      for orig_key, orig_value in next, orig, nil do
          copy[helpers.deepcopy(orig_key)] = helpers.deepcopy(orig_value)
      end
      setmetatable(copy, helpers.deepcopy(getmetatable(orig)))
  else -- number, string, boolean, etc
      copy = orig
  end
  return copy
end

function helpers.get_key_for_value( t, value )
    for k,v in pairs(t) do
      if v==value then return k end
    end
    return nil
  end

function helpers.debugWrap(fcn)
    print('wrapper applied')
    return function (...)
        local arg = {...}
        arg.n = select("#", ...)
        -- print('function name:', get_key_for_value(VampiricTouch, fcn))
        -- print('argdump')
        -- print(inspect(arg))
        return fcn(unpack(arg, 1))  
    end
end

function helpers.tableLength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

return helpers