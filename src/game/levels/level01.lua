return function()

    print('-- Building level 01');
    app.game.rooms = {}

    --------------------------------------------

    local room1 = Room:new({
        x = -1,
        y = 0
    });

    room1:addWall(Room.TOP)
    room1:addWall(Room.LEFT)
    room1:addWall(Room.BOTTOM)

    if(not app.game.rooms[room1.x]) then app.game.rooms[room1.x] = {} end
    app.game.rooms[room1.x][room1.y] = room1

    --------------------------------------------

    local room2 = Room:new({
        x = 0,
        y = 0
    });

    room2:addWall(Room.TOP)
    room2:addWall(Room.BOTTOM)
    room2:addWall(Room.RIGHT)

    if(not app.game.rooms[room2.x]) then app.game.rooms[room2.x] = {} end
    app.game.rooms[room2.x][room2.y] = room2

    --------------------------------------------

    room1:show()
    room2:show()

    --------------------------------------------

    local frog = Frog:new({
        room = room1
    })

    frog:show()

    --------------------------------------------

end
