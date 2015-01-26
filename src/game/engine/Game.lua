--------------------------------------------------------------------------------

Game = {
    RUNNING = 1,
    STOPPED = 2,

    COLORS = {
        BLACK  = 1,
        RED    = 2,
        YELLOW = 3,
        GREEN  = 4,
        BLUE   = 5
    },

    COLOR_NAMES = {
        'black',
        'red',
        'yellow',
        'green',
        'blue'
    },

}

--------------------------------------------------------------------------------

function Game:new()
    local game = {
        state = Game.STOPPED,

        -- filled by each Level
        rooms = {}
    }

    setmetatable(game, { __index = Game })
    return game
end

--------------------------------------------------------------------------------

function Game:start()
    self.state = Game.RUNNING
end

------------------------------------------

function Game:stop()

    if(self.state == Game.STOPPED) then return end

    ------------------------------------------

    self.state = Game.STOPPED

    ------------------------------------------
    -- score

    local score = {

    }

end

--------------------------------------------------------------------------------

function Game:loadLevel(level)
    level()
    self:start()
end

--------------------------------------------------------------------------------

function Game:nextRoom(room, direction)
    local nextRoom = nil

    if(direction == Room.TOP) then
        if(self.rooms[room.x] and self.rooms[room.x][room.y - 1]) then
            nextRoom = self.rooms[room.x][room.y - 1]
        end

    elseif(direction == Room.BOTTOM) then
        if(self.rooms[room.x] and self.rooms[room.x][room.y + 1]) then
            nextRoom = self.rooms[room.x][room.y + 1]
        end

    elseif(direction == Room.RIGHT) then
        if(self.rooms[room.x + 1] and self.rooms[room.x + 1][room.y]) then
            nextRoom = self.rooms[room.x + 1][room.y]
        end

    elseif(direction == Room.LEFT) then
        if(self.rooms[room.x - 1] and self.rooms[room.x - 1][room.y]) then
            nextRoom = self.rooms[room.x - 1][room.y]
        end

    end

    return nextRoom
end
--------------------------------------------------------------------------------

--
-- to understand 'door[action](door)' -> note about self and colon here :
-- http://www.lua.org/pil/16.html
--
function Game:activateDoors(color, action)
    for x,line in pairs(self.rooms) do
        for y,room in pairs(line) do
            for l,door in pairs(room.doors) do
                if(door.color == color) then
                    door[action](door)
                end
            end
        end
    end
end

------------------------------------------

return Game
