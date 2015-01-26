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
end

--------------------------------------------------------------------------------

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
    -- buildSheet()
    app.game:loadLevel(LevelTest1)
    -- app.game:loadLevel(Level01)
end

--- To build a lua sheet config from PNG
function buildSheet()
    local r = {}
    local height = 42
    local width = 33

    local lines = 1
    local columns = 7

    for j = 1,lines do
        for i = columns,1,-1 do
            r[i + (j-1)*columns] = {
                x = 0 + (i-1)*width,
                y = 0 + (j-1)*height,
                height = height,
                width = width
            }
        end
    end

    utils.table.show(r, 'r');
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
