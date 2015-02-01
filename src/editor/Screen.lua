--------------------------------------------------------------------------------
---
--------------------------------------------------------------------------------

local Screen = {}

--------------------------------------------------------------------------------

function Screen:prepare()

    app.screen   = display.newGroup()
    app.screen.x = ITEMS_WIDTH
    app.screen.y = TOOLBAR_HEIGHT

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

    --------------------------------------

    levelBuilder:reset()
end

--------------------------------------------------------------------------------

return Screen
