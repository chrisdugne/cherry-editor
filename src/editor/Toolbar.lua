--------------------------------------------------------------------------------
---
--------------------------------------------------------------------------------

local Toolbar = {}

--------------------------------------------------------------------------------

Toolbar.prepare = function ()

    app.toolbar = display.newGroup()

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

    local toCenter = display.newImage(
        app.toolbar,
        'assets/images/editor/noun_33953_cc.png',
        buttonX(1), TOOLBAR_HEIGHT/2
    )

    toCenter.anchorX = 0

    utils.onTouch(toCenter, function()
        Tools.centerLevel()
    end)

    --------------------------------------
    -- Button toggle grid snapping

    local snapping = display.newImage(
        app.toolbar,
        'assets/images/editor/snap-grid.png',
        buttonX(2), TOOLBAR_HEIGHT/2
    )

    snapping.anchorX = 0

    utils.onTouch(snapping, function()
        app.screen.gridVisible = not app.screen.gridVisible
        if(app.screen.gridVisible) then
            Tools.showSnapGrid()
        else
            Tools.hideSnapGrid()
        end
    end)

end

-------------------------------------

function buttonX(position)
    return 10 + 70 * ( position - 1 )
end

-------------------------------------

return Toolbar
