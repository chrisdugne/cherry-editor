--------------------------------------------------------------------------------
---
--------------------------------------------------------------------------------

local Screen = {}

--------------------------------------------------------------------------------

function Screen:prepare ()

    app.screen   = display.newGroup()
    app.screen.x = ITEMS_WIDTH
    app.screen.y = TOOLBAR_HEIGHT

    --------------------------------------

    app.screen.gridVisible = false

    --------------------------------------

    app.screenBounds = display.newRect(
        app.screen,
        0, 0,
        SCREEN_WIDTH,
        SCREEN_HEIGHT
    )

    app.screenBounds.anchorX = 0
    app.screenBounds.anchorY = 0
    app.screenBounds:setFillColor( 0.12 )

    app.screen.level = display.newGroup()
    app.screen:insert(app.screen.level)

    touchController:addTap(app.screen, function(event)
        levelBuilder:addItem(event)
    end)

    touchController:addDrag(app.screen, app.screen.level)

    --------------------------------------

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

    Tools.centerLevel()

end

-------------------------------------

return Screen
