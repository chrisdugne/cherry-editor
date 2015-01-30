--------------------------------------------------------------------------------

local App = {}

--------------------------------------------------------------------------------

function App:new()
    local object = {
        hud = display.newGroup()
    }
    setmetatable(object, { __index = App })
    return object
end

--------------------------------------------------------------------------------

function App:start()

    APP_NAME    = 'Doors Editor'
    APP_VERSION = '1.0'

    ----------------------------------------------------------------------------

    LEVELS_FOLDER = '/Users/mad/Projects/Uralys/Doors/assets/levels'
    EXPORT_LEVEL  = '/level-editor/level-editor.json'
    IMPORT_LEVEL  = '/level-editor/level-editor.json'
    -- IMPORT_LEVEL  = '/chapter-1/level-1.json'

    ----------------------------------------------------------------------------

    print('---------------------- '
        .. APP_NAME
        .. ' ----------------')

    ----------------------------------------------------------------------------
    --- iOS Status Bar

    display.setStatusBar( display.HiddenStatusBar )

    ----------------------------------------------------------------------------

    IOS         = system.getInfo( 'platformName' )  == 'iPhone OS'
    ANDROID     = system.getInfo( 'platformName' )  == 'Android'
    SIMULATOR   = system.getInfo( 'environment' )   == 'simulator'

    ----------------------------------------------------------------------------

    app:prepareGlobals()
    app:open()

end

--------------------------------------------------------------------------------

function App:prepareGlobals()

    SCREEN_WIDTH  = display.contentWidth  * 0.8
    SCREEN_HEIGHT = display.contentHeight * 0.9

    ITEMS_WIDTH  = display.contentWidth  * 0.2
    ITEMS_HEIGHT = display.contentHeight * 0.9

    TOOLBAR_WIDTH  = display.contentWidth
    TOOLBAR_HEIGHT = display.contentHeight * 0.1

    Room = {
        TOP    = 1,
        RIGHT  = 2,
        BOTTOM = 3,
        LEFT   = 4,

        WIDTH  = 100,
        HEIGHT = 100
    }

end

--------------------------------------------------------------------------------

function App:open()
    self:initBackground();
    storyboard.gotoScene( 'src.views.Editor' )
end

--------------------------------------------------------------------------------

function App:initBackground()
    display.setDefault( "background", 30/255, 30/255, 30/255 )
end

--------------------------------------------------------------------------------

return App
