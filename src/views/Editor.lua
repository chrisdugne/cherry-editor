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

    app.screen:addEventListener( "touch", function(event)
        touchController.drag(app.screen.level, event)
    end)

    --------------------------------------

    local center1 = display.newLine( app.screen.level, 0, -Room.HEIGHT/4, 0, Room.HEIGHT/4)
    local center2 = display.newLine( app.screen.level, -Room.WIDTH/4, 0, Room.WIDTH/4, 0)

    center1.strokeWidth = 2
    center2.strokeWidth = 2
    center1:setStrokeColor( 225/255, 25/255, 125/255 )
    center2:setStrokeColor( 225/255, 25/255, 125/255 )
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
    -- Button to center

    local toCenter = display.newImage(
        app.toolbar,
        'assets/images/editor/noun_33953_cc.png',
        buttonX(1), TOOLBAR_HEIGHT/2
    )

    toCenter.anchorX = 0

    utils.onTouch(toCenter, function()
        centerLevel()
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
            showSnapGrid()
        else
            hideSnapGrid()
        end
    end)
end

--------------------------------------------------------------------------------

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

    local lfs = require "lfs"

    local baseDir = system.pathForFile('main.lua'):gsub("main.lua", "")
    local rooms   = baseDir .. 'assets/images/rooms/'

    local verticalPosition = 1
    for file in lfs.dir(rooms) do
        if(not utils.string.startsWith(file, '.')) then
            local item =  display.newImage(
                app.items,
                'assets/images/rooms/' .. file,
                120, 50 + verticalPosition * 120
            )

            verticalPosition = verticalPosition + 1
            app.items:insert(item)
        end
    end
end

--------------------------------------------------------------------------------

function buttonX(position)
    return 10 + 70 * ( position - 1 )
end

--------------------------------------------------------------------------------

function hideSnapGrid()
    display.remove(app.screen.grid)
    app.screen.grid = nil
end

function showSnapGrid()
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
