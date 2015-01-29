--------------------------------------------------------------------------------
---
--------------------------------------------------------------------------------

local Tools = {}

--------------------------------------------------------------------------------

function Tools:centerLevel ()
    app.screen.level.x = SCREEN_WIDTH/2
    app.screen.level.y = SCREEN_HEIGHT/2
end

--------------------------------------------------------------------------------

function Tools:toggleSnapGrid ()
    app.screen.gridVisible = not app.screen.gridVisible
    if(app.screen.gridVisible) then
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

        hLine.stroke.effect = "generator.marchingAnts"
        hLine.strokeWidth = 2
        hLine:setStrokeColor( 245/255, 245/255, 245/255 )

        vLine.stroke.effect = "generator.marchingAnts"
        vLine.strokeWidth = 2
        vLine:setStrokeColor( 245/255, 245/255, 245/255 )

    end

    app.screen.level:insert(app.screen.grid)

end

-------------------------------------

return Tools
