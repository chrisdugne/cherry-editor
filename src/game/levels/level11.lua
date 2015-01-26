return function()

    print('-- Building level 11');

    --------------------------------------------

    local room1 = Room:new({
        x = -1,
        y = 0
    });

    room1:addWall(Room.TOP)
    room1:addWall(Room.LEFT)
    room1:addWall(Room.BOTTOM)

    --------------------------------------------

    local room2 = Room:new({
        x = 0,
        y = 0
    });

    room2:addWall(Room.TOP)
    room2:addWall(Room.BOTTOM)

    --------------------------------------------

    room1:show()
    room2:show()

end
