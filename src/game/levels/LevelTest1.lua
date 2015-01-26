return function()

    print('-- Building level Test 1');

    --------------------------------------------

    local room = Room:new({
        x = 0,
        y = 0
    })

    room:addDoor(Room.TOP, {
        color = Game.COLORS.BLUE
    })

    room:addDoor(Room.RIGHT, {
        color = Game.COLORS.RED
    })

    room:addDoor(Room.BOTTOM, {
        color = Game.COLORS.RED
    })

    room:addDoor(Room.LEFT, {
        color = Game.COLORS.RED
    })

    if(not app.game.rooms[room.x]) then app.game.rooms[room.x] = {} end
    app.game.rooms[room.x][room.y] = room

    --------------------------------------------

    local room2 = Room:new({
        x = 1,
        y = 0
    });

    room2:addWall(Room.TOP)
    room2:addWall(Room.RIGHT)

    room2:addTrigger({
        color = Game.COLORS.RED
    })

    if(not app.game.rooms[room2.x]) then app.game.rooms[room2.x] = {} end
    app.game.rooms[room2.x][room2.y] = room2

    --------------------------------------------

    local room3 = Room:new({
        x = 1,
        y = 1,
        color = Game.COLORS.BLUE
    });

    room3:addWall(Room.RIGHT)
    room3:addWall(Room.BOTTOM)
    room3:addWall(Room.LEFT)

    if(not app.game.rooms[room3.x]) then app.game.rooms[room3.x] = {} end
    app.game.rooms[room3.x][room3.y] = room3

    --------------------------------------------

    room:show()
    room2:show()
    room3:show()

    -- room.doors[Room.TOP]:open(function()
    --     room.doors[Room.TOP]:close()
    --     room.doors[Room.RIGHT]:open()
    --     room.doors[Room.LEFT]:open()
    --     room.doors[Room.BOTTOM]:open()
    -- end)

    --------------------------------------------

    local frog = Frog:new({
        room = room3
    })

    frog:show()
end
