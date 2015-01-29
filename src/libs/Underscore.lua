--------------------------------------------------------------------------------
---
-- Picking up Underscore tools from :
-- https://github.com/mirven/underscore.lua/blob/master/lib/underscore.lua
--
--------------------------------------------------------------------------------

local Underscore = {}

--------------------------------------------------------------------------------

function Underscore:extend (destination, source)
    for k,v in pairs(source) do
    destination[k] = v
    end
    return destination
end

-------------------------------------

return Underscore
