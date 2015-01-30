--------------------------------------------------------------------------------
---
--------------------------------------------------------------------------------

local Toolbar = {}

--------------------------------------------------------------------------------

function Toolbar:prepare ()

    app.toolbar = display.newGroup()
    touchController:stopPropagation(app.toolbar)

    --------------------------------------

    app.toolbarBounds = display.newRect(
        app.toolbar,
        0, 0,
        TOOLBAR_WIDTH,
        TOOLBAR_HEIGHT
    )

    app.toolbarBounds.anchorX = 0
    app.toolbarBounds.anchorY = 0

    app.toolbarBounds.strokeWidth = 1
    app.toolbarBounds:setFillColor( 0.12 )
    app.toolbarBounds:setStrokeColor( 225/255, 225/255, 225/255 )

    --------------------------------------
    -- Button to center

    addButton(1, 'assets/images/editor/noun_33953_cc.png', Tools.centerLevel)

    --------------------------------------
    -- Button toggle grid snapping

    addButton(2, 'assets/images/editor/snap-grid.png', Tools.toggleSnapGrid)

    --------------------------------------
    -- Button to import

    addButton(16, 'assets/images/editor/noun_25665_cc.png', function()
        levelBuilder:export()
    end)

    --------------------------------------
    -- Button to export

    addButton(17, 'assets/images/editor/noun_20381_cc.png', function()
        levelBuilder:export()
    end)

end

-------------------------------------

function addButton(position, icon, action)
    local button = display.newImage(
        app.toolbar,
        icon,
        buttonX(position),
        TOOLBAR_HEIGHT/2
    )

    button.anchorX = 0

    utils.onTouch(button, action)
end

-------------------------------------

function buttonX(position)
    return 10 + 70 * ( position - 1 )
end

-------------------------------------

return Toolbar
