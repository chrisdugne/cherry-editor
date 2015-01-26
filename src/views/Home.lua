--------------------------------------------------------------------------------
--
-- AppHome.lua
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

function scene:refreshScene()
    app.hud.title              = display.newText( app.hud, "Doors" , 0, 0, FONT, 275 )
    app.hud.title.x            = display.contentWidth*0.5
    app.hud.title.y            = display.contentHeight*0.1
    app.hud.title.anchorY      = 0.7
    app.hud.title:scale(0.38,0.38)

    effectsManager.atmosphere(display.contentWidth*0.2,  app.hud.title.y , 0.9)
    effectsManager.atmosphere(display.contentWidth*0.8,  app.hud.title.y , 0.9)
    effectsManager.start()

    local playButton = display.newImage(app.hud, 'assets/images/play.png',
        display.contentWidth*0.5,
        display.contentHeight*0.5
    );

    utils.onTouch(playButton, function()
        app.router:open(app.router.PLAYGROUND)
    end);

end

--------------------------------------------------------------------------------

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
    self:refreshScene()
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
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
