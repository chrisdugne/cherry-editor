--------------------------------------------------------------------------------

local Frog = {}

--------------------------------------------------------------------------------

local TOP    = 1
local RIGHT  = 2
local BOTTOM = 3
local LEFT   = 4

--------------------------------------------------------------------------------

function Frog:new(options)
    local frog = _.extend({
        room = nil
    }, options);

    setmetatable(frog, { __index = Frog })
    return frog;
end

--------------------------------------------------------------------------------

function Frog:swipe(direction)
    if(self:checkExit(self.room, direction)) then
        nextRoom = app.game:nextRoom(self.room, direction)

        if(self:checkEntrance(nextRoom, direction)) then
            self:changeRoom(nextRoom, direction)
        end
    end
end

-- frog wants to leave the room using this direction
function Frog:checkExit(room, direction)
    if(room and room:exitEnabled(direction)) then
        return true
    else
        self:bumpOnDoor()
        return false
    end
end

-- frog wants to enter the room using this direction
function Frog:checkEntrance(room, direction)
    local oppositeDirection = (direction + 2)%4
    if(oppositeDirection == 0 ) then oppositeDirection = 4 end

    if(room and room:exitEnabled(oppositeDirection)) then
        return true
    else
        self:bumpOnDoor()
        return false
    end
end

function Frog:bumpOnDoor(direction)
    -- TODO
end

function Frog:changeRoom(nextRoom, direction)
    self.isMoving = true
    self.room:leave()
    self.room = nextRoom
    self.room:enter()

    local xTo = self.display.x
    local yTo = self.display.y

    if(direction == Room.TOP) then
        yTo = self.display.y - Room.HEIGHT

    elseif(direction == Room.BOTTOM) then
        yTo = self.display.y + Room.HEIGHT

    elseif(direction == Room.RIGHT) then
        xTo = self.display.x + Room.WIDTH

    elseif(direction == Room.LEFT) then
        xTo = self.display.x - Room.WIDTH

    end

    transition.to( self.display, {
        time = 150,
        x    = xTo,
        y    = yTo,
        onComplete = function()
            self.isMoving = false
        end
    })
end

--------------------------------------------------------------------------------

function Frog:show()
    local frogSheet = require("src.game.graphics.FrogIdle")
    local frogImageSheet = graphics.newImageSheet(
        "assets/images/sheets/frog.idle.png",
        frogSheet.sheet
    )

    self.display = display.newSprite(
        app.hud,
        frogImageSheet ,
        frogSheet:newSequence()
    )

    self.display.x = self.room.display.x
    self.display.y = self.room.display.y + 12
    self.display:play()

    self:listen()
end

--------------------------------------------------------------------------------

function Frog:listen()
    local function handleSwipe( event )
        if(self.isMoving) then return false end

        if ( event.phase == "moved" ) then
            local dX = event.x - event.xStart
            local dY = event.y - event.yStart

            if ( dX > 10 ) then
                self:swipe(RIGHT);

            elseif ( dX  < -10 ) then
                self:swipe(LEFT);

            elseif ( dY  > 10 ) then
                self:swipe(BOTTOM);

            elseif ( dY  < -10 ) then
                self:swipe(TOP);

            end
        end

        return true
    end

    self.display:addEventListener( "touch", handleSwipe )
end

--------------------------------------------------------------------------------

return Frog
