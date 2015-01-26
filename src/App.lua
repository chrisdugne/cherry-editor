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

    print('---------------------- '
        .. APP_NAME
        .. ' ----------------')

    ----------------------------------------------------------------------------
    --- iOS Status Bar

    display.setStatusBar( display.HiddenStatusBar )

    ----------------------------------------------------------------------------

    app:open()

end

--------------------------------------------------------------------------------

function App:open()
    self:initBackground();
    storyboard.gotoScene( 'src.views.Editor' )
end

--------------------------------------------------------------------------------

function App:initBackground()
    display.setDefault( "background", 30/255, 30/255, 30/255 )
    self.hud = display.newGroup()
end

--------------------------------------------------------------------------------

return App
