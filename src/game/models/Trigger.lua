--------------------------------------------------------------------------------

local Trigger = {
    DOOR_SWITCH   = 1,
    ROOM_ROTATOR  = 2,
    ROOM_MOVER    = 3,
    MOVE_REPEATER = 4,
    MOVE_LEADER   = 5,

    ON_ENTER      = 1,
    ON_LEAVE      = 2,

    OFF           = 0,
    ON            = 1
}

--------------------------------------------------------------------------------

function Trigger:new(options)
    local trigger = _.extend({
        type  = Trigger.DOOR_SWITCH,
        when  = Trigger.ON_ENTER,
        state = Trigger.OFF
    }, options);

    setmetatable(trigger, { __index = Trigger })
    return trigger;
end

--------------------------------------------------------------------------------

-- note :
-- 30 * (-1)^(when+1) = +30 ON_ENTER
--                    = -30 ON_LEAVE
--
function Trigger:tryToActivate(when)
    transition.to(self.display, {
        x = self.display.x + 30 * (-1)^(when+1),
        time = 150,
        onComplete = function ()
            if(when == self.when) then
                self:activate()
            end
        end
    })
end

--------------------------------------------------------------------------------

function Trigger:show()
    local color = Game.COLOR_NAMES[self.color]
    local name  = 'trigger.'.. self.type ..'.'.. color ..'.png'
    local png   = 'assets/images/sheets/triggers/' .. name

    local triggerSheet = require("src.game.graphics.Trigger" .. self.type)
    local triggerImageSheet = graphics.newImageSheet( png, triggerSheet.sheet )

    self.display   = display.newSprite(
        app.hud,
        triggerImageSheet ,
        triggerSheet:newSequence()
    )

    self.display.x = self.room.display.x
    self.display.y = self.room.display.y + 12
    self.display:setFrame(triggerSheet:frame('off'))
end

--------------------------------------------------------------------------------

function Trigger:activate(when)
    if(self.type == Trigger.DOOR_SWITCH) then
        self:activateDoorSwitch()
    end
end

--------------------------------------------------------------------------------

function Trigger:activateDoorSwitch(when)
    if(self.state == Trigger.OFF) then
        self.display:setSequence('switch-on')
        self.state = Trigger.ON
        app.game:activateDoors(self.color, 'open')

    elseif(self.state == Trigger.ON) then
        self.display:setSequence('switch-off')
        self.state = Trigger.OFF
        app.game:activateDoors(self.color, 'close')

    end

    self.display:play()
end

--------------------------------------------------------------------------------

return Trigger
