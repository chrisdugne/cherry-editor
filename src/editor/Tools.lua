--------------------------------------------------------------------------------
---
--------------------------------------------------------------------------------

local Tools = {}

--------------------------------------------------------------------------------

function Tools:drawCenter ()

    local center1 = display.newLine(
        app.screen.level, 0, -Room.HEIGHT/4, 0, Room.HEIGHT/4
    )

    local center2 = display.newLine(
        app.screen.level, -Room.WIDTH/4, 0, Room.WIDTH/4, 0
    )

    center1.strokeWidth = 2
    center2.strokeWidth = 2
    center1:setStrokeColor( 225/255, 25/255, 125/255 )
    center2:setStrokeColor( 225/255, 25/255, 125/255 )

end

--------------------------------------------------------------------------------

function Tools:centerLevel ()
    app.screen.level.x = SCREEN_WIDTH/2
    app.screen.level.y = SCREEN_HEIGHT/2
end

--------------------------------------------------------------------------------

function Tools:toggleSnapGrid ()
    if(not app.screen.grid) then
        Tools.showSnapGrid()
    else
        Tools.hideSnapGrid()
    end
end

--------------------------------------------------------------------------------

function Tools:hideSnapGrid ()
    display.remove(app.screen.grid)
    app.screen.grid = nil
end

--------------------------------------------------------------------------------

function Tools:showSnapGrid ()

    app.screen.grid = display.newGroup()
    app.screen.grid.lines = {}

    for i=1,41 do
        local hLine = display.newLine(
            app.screen.grid,
            -Room.WIDTH*20,
            Room.HEIGHT * (i-21),
            Room.WIDTH*20,
            Room.HEIGHT * (i-21)
        )

        local vLine = display.newLine(
            app.screen.grid,
            Room.WIDTH * (i-21),
            -Room.HEIGHT*20,
            Room.WIDTH * (i-21),
            Room.HEIGHT*20
        )

        hLine.strokeWidth = 2
        hLine:setStrokeColor( 75/255, 75/255, 75/255 )

        vLine.strokeWidth = 2
        vLine:setStrokeColor( 75/255, 75/255, 75/255 )

    end

    app.screen.level:insert(app.screen.grid)

end

-------------------------------------

return Tools
