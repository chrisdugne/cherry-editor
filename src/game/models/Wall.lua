--------------------------------------------------------------------------------

local Wall = {
    WIDTH = 100
}

--------------------------------------------------------------------------------
---
-- options must contain
--  'room'
--  'direction'
--
function Wall:new(options)
    local wall = _.extend({
        display = nil
    }, options);

    setmetatable(wall, { __index = Wall })
    return wall;
end

--------------------------------------------------------------------------------

function Wall:isOpen()
    return false
end

--------------------------------------------------------------------------------

function Wall:show()
    local image = 'assets/images/wall.png'
    self.display = display.newImage(
        app.hud,
        image,
        self.room.display.x,
        self.room.display.y
    )

    self.display.rotation = (90 * (self.direction - 1))
end

function Wall:hide()
    display.remove(self.display)
    self.display = nil
end

--------------------------------------------------------------------------------

return Wall
