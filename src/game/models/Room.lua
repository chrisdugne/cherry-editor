--------------------------------------------------------------------------------

local Room = {

    TOP    = 1,
    RIGHT  = 2,
    BOTTOM = 3,
    LEFT   = 4,

    WIDTH  = 100,
    HEIGHT = 100
}

--------------------------------------------------------------------------------

function Room:new(options)
    local room = _.extend({
        color    = Game.COLORS.BLACK,
        doors    = {},
        triggers = {},
        display  = nil
    }, options);

    setmetatable(room, { __index = Room })
    return room;
end

--------------------------------------------------------------------------------
-- state

function Room:enter()
    self:trigger(Trigger.ON_ENTER)
end

function Room:leave()
    self:trigger(Trigger.ON_LEAVE)
end

function Room:trigger(when)
    for k,trigger in pairs(self.triggers) do
        trigger:tryToActivate(when)
    end
end

function Room:rotate(angle)
    self.display.rotation = (self.display.rotation + angle) % 360
end

--------------------------------------------------------------------------------
-- display

function Room:show()
    local image = 'assets/images/room.'.. Game.COLOR_NAMES[self.color] ..'.png'

    self.display = display.newImage(
        app.hud,
        image,
        display.contentWidth/2 + Room.WIDTH * self.x,
        display.contentHeight/2 + Room.HEIGHT * self.y
    )

    for k,door in pairs(self.doors) do
        door:show()
    end

    for k,trigger in pairs(self.triggers) do
        trigger:show()
    end
end

--------------------------------------------------------------------------------
-- API

-- return true if this room may be left using this direction
function Room:exitEnabled(direction)
    local door = ((direction - self.display.rotation/90) % 4)
    if(door == 0) then door = 4 end
    return not self.doors[door] or self.doors[door]:isOpen();
end

function Room:addDoor(direction, options)
    self.doors[direction] = Door:new(_.extend({
        room = self,
        direction = direction
    }, options))
end

function Room:addWall(direction)
    self.doors[direction] = Wall:new({
        room = self,
        direction = direction
    })
end

function Room:addTrigger(options)
    self.triggers[#self.triggers + 1] = Trigger:new(_.extend({
        room = self
    }, options))
end

--------------------------------------------------------------------------------

return Room
