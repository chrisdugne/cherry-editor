--------------------------------------------------------------------------------
--
-- Playground.lua
--
--------------------------------------------------------------------------------

local scene = storyboard.newScene()

--------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
--
-- NOTE: Code outside of listener functions (below) will only be executed once,
--         unless storyboard.removeScene() is called.
--

--------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
    prepareScreen()
    prepareToolbar()
    prepareMenu()
    touchController.start()
end

--------------------------------------------------------------------------------

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
end

--------------------------------------------------------------------------------

function prepareScreen()
    app.screen        = display.newGroup()
    app.screen.x      = ITEMS_WIDTH
    app.screen.y      = TOOLBAR_HEIGHT

    --------------------------------------

    -- prepare for toucheController dragging
    app.screen.markX   = 0
    app.screen.markY   = 0
    app.screen.offsetX = 0
    app.screen.offsetY = 0
    app.screen.xStart  = 0
    app.screen.yStart  = 0

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

    --------------------------------------

    local center = display.newRect(
        app.screen.level,
        0, 0,
        Room.WIDTH,
        Room.HEIGHT
    )

    center.strokeWidth = 1
    center:setFillColor( 0.12 )
    center:setStrokeColor( 225/255, 25/255, 125/255 )
    centerLevel()

end

--------------------------------------------------------------------------------

function prepareToolbar()
    app.toolbar       = display.newGroup()

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

    local toCenter = display.newImage(
        app.toolbar,
        'assets/images/editor/noun_33953_cc.png',
        10, TOOLBAR_HEIGHT/2
    )

    toCenter.anchorX = 0
    toCenter:scale(0.8, 0.8)

    utils.onTouch(toCenter, function()
        centerLevel()
    end)
end

function centerLevel()
    app.screen.level.x = SCREEN_WIDTH/2
    app.screen.level.y = SCREEN_HEIGHT/2
end

--------------------------------------------------------------------------------

function prepareMenu()
    app.items = display.newGroup()

    app.itemsBounds = display.newRect(
        app.items,
        0,
        TOOLBAR_HEIGHT + 1, -- note : +1 -> strokeWidth
        ITEMS_WIDTH,
        ITEMS_HEIGHT
    )

    app.itemsBounds.anchorX = 0
    app.itemsBounds.anchorY = 0

    app.itemsBounds.strokeWidth = 1
    app.itemsBounds:setFillColor( 0.12 )
    app.itemsBounds:setStrokeColor( 225/255, 225/255, 225/255 )
end

--------------------------------------------------------------------------------

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
    Runtime:removeEventListener( "enterFrame", self.refreshCamera )
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
end

--------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
--------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

--------------------------------------------------------------------------------

return scene
