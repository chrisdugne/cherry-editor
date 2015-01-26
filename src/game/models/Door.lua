--------------------------------------------------------------------------------

local Door = {

    OPEN   = 1,
    CLOSED = 2,

    WIDTH = 50
}

--------------------------------------------------------------------------------
---
-- options must contain
--  'room'
--  'direction'
--
function Door:new(options)
    local door = _.extend({
        state   = Door.CLOSED,
        color   = Game.COLORS.RED,
        display = nil
    }, options);

    setmetatable(door, { __index = Door })
    return door;
end

--------------------------------------------------------------------------------

function Door:open(next)
    self.state = Door.OPEN

    transition.to(self.display.left, {
        x = - Door.WIDTH
    })

    transition.to(self.display.right, {
        x = Door.WIDTH * 2,
        onComplete = next
    })

end

function Door:close(next)
    self.state = Door.CLOSED

    transition.to(self.display.left, {
        x = 0
    })

    transition.to(self.display.right, {
        x = Door.WIDTH,
        onComplete = next
    })
end

function Door:isOpen()
    return self.state == Door.OPEN
end

--------------------------------------------------------------------------------

---
-- the door is displayed within a frame
--
function Door:show()
    local frame = display.newGroup()
    app.hud:insert(frame)

    local mask  = graphics.newMask( 'assets/images/room.mask.png' )
    local image = 'assets/images/door.'.. Game.COLOR_NAMES[self.color] ..'.png'

    frame.x = self.room.display.x
    frame.y = self.room.display.y
    frame:setMask(mask)
    frame.rotation = (90 * (self.direction - 1))

    self.display = {
        left  = display.newImage(frame, image, 0, 0),
        right = display.newImage(frame, image, Door.WIDTH, 0)
    }
end

function Door:hide()
    display.remove(self.display.left)
    display.remove(self.display.right)
    self.display = nil
end

--------------------------------------------------------------------------------

return Door
