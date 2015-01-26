--------------------------------------------------------------------------------
---
-- Picking up Underscore tools from :
-- https://github.com/mirven/underscore.lua/blob/master/lib/underscore.lua
--
--------------------------------------------------------------------------------

local Underscore = {}

--------------------------------------------------------------------------------

Underscore.extend = function (destination, source)
    for k,v in pairs(source) do
    destination[k] = v
    end
    return destination
end

-------------------------------------

return Underscore
