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

    APP_NAME    = 'Doors'
    APP_VERSION = '0.9'

    ----------------------------------------------------------------------------
    -- Dev overiddes

    -- DEV_LANG = 'fr'
    -- DEV_COUNTRY = 'US'

    ----------------------------------------------------------------------------

    print('---------------------- '
        .. APP_NAME
        .. ' ----------------')

    ----------------------------------------------------------------------------

    app:deviceSetup()
    app:setup()
    app:open()

end

--------------------------------------------------------------------------------

function App:setup()

    print('application setup...')

    ----------------------------------------------------------------------------
    ---- App globals

    GLOBALS = {
        savedData = utils.loadUserData('savedData.json'),
        options   = utils.loadUserData('options.json')
    }

    ----------------------------------------------------------------------------

    FACEBOOK_PAGE_ID = '379432705492888'
    FACEBOOK_PAGE    = 'https://www.facebook.com/uralys'

    ----------------------------------------------------------------------------

    ANALYTICS_VERSION     = 1
    ANALYTICS_TRACKING_ID = 'UA-XXXX-X'
    ANALYTICS_PROFILE_ID  = 'XXXXXX'

    analytics.init(
        ANALYTICS_VERSION,
        ANALYTICS_TRACKING_ID,
        ANALYTICS_PROFILE_ID,
        APP_NAME,
        APP_VERSION
    )

    ----------------------------------------------------------------------------

    IOS         = system.getInfo( 'platformName' )  == 'iPhone OS'
    ANDROID     = system.getInfo( 'platformName' )  == 'Android'
    SIMULATOR   = system.getInfo( 'environment' )   == 'simulator'

    ----------------------------------------------------------------------------

    translations = require('assets.Translations')

    -- if ANDROID then
    --     FONT   = 'GillSans'
    --     NUM_FONT = 'HelveticaBold'
    -- else
    --     FONT   = 'Gill Sans'
    --     NUM_FONT = 'Helvetica-Bold'
    -- end

    ----------------------------------------------------------------------------

    if(ANDROID) then
        LANG = userDefinedLanguage or system.getPreference('locale', 'language')
    else
        LANG = userDefinedLanguage or system.getPreference('ui', 'language')
    end

    -- LANG not supported : default en
    if(LANG ~= 'en' and LANG ~= 'fr') then LANG = 'en' end

    -- dev overiddes
    if(DEV_LANG) then LANG = DEV_LANG end

    ----------------------------------------------------------------------------

    COUNTRY = system.getPreference( 'locale', 'country' ) or 'US'

    -- dev overiddes
    if(DEV_COUNTRY) then COUNTRY = DEV_COUNTRY end

    ----------------------------------------------------------------------------

    aspectRatio = display.pixelHeight / display.pixelWidth

    ----------------------------------------------------------------------------

    abs         = math.abs
    random      = math.random

    ----------------------------------------------------------------------------

end

--------------------------------------------------------------------------------

function App:deviceSetup()

    print('device setup...')

    ----------------------------------------------------------------------------
    -- prepare notifications for this session
    -- these notifications can be removed as long as the app is ON

    self.deviceNotifications = {}

    ----------------------------------------------------------------------------
    --- iOS Status Bar
    display.setStatusBar( display.HiddenStatusBar )

    ------------------------------------------
    --- ANDROID BACK BUTTON

    local function onKeyEvent( event )

        local phase = event.phase
        local keyName = event.keyName
        print( event.phase, event.keyName )

        if ( 'back' == keyName and phase == 'up' ) then
            if ( storyboard.currentScene == 'splash' ) then
                native.requestExit()
            else
                if ( storyboard.isOverlay ) then
                    storyboard.hideOverlay()
                else
                    local lastScene = storyboard.returnTo
                    print( 'previous scene', lastScene )
                    if ( lastScene ) then
                        storyboard.gotoScene( lastScene, {
                            effect='crossFade',
                            time=500
                        })
                    else
                        native.requestExit()
                    end
                end
            end
        end

        if ( keyName == 'volumeUp' and phase == 'down' ) then
            local masterVolume = audio.getVolume()
            print( 'volume:', masterVolume )
            if ( masterVolume < 1.0 ) then
                masterVolume = masterVolume + 0.1
                audio.setVolume( masterVolume )
            end
        elseif ( keyName == 'volumeDown' and phase == 'down' ) then
            local masterVolume = audio.getVolume()
            print( 'volume:', masterVolume )
            if ( masterVolume > 0.0 ) then
                masterVolume = masterVolume - 0.1
                audio.setVolume( masterVolume )
            end
        end

        return true  --SEE NOTE BELOW
    end

    --add the key callback
    Runtime:addEventListener( 'key', onKeyEvent )

    ----------------------------------------------------------------------------

    local function myUnhandledErrorListener( event )

        local iHandledTheError = true

        if iHandledTheError then
            print( 'Handling the unhandled error', event.errorMessage )
        else
            print( 'Not handling the unhandled error', event.errorMessage )
        end

        return iHandledTheError
    end

    Runtime:addEventListener('unhandledError', myUnhandledErrorListener)

    ----------------------------------------------------------------------------

    --
    --
    --local fonts = native.getFontNames()
    --
    --count = 0
    --
    ---- Count the number of total fonts
    --for i,fontname in ipairs(fonts) do
    --    count = count+1
    --end
    --
    --print( '\rFont count = ' .. count )
    --
    --local name = 'pt'     -- part of the Font name we are looking for
    --
    --name = string.lower( name )
    --
    ---- Display each font in the terminal console
    --for i, fontname in ipairs(fonts) do
    --
    --        print( 'fontname = ' .. tostring( fontname ) )
    --end
end

--------------------------------------------------------------------------------

function App:deviceNotification(text, secondsFromNow, id)

    print('----> deviceNotification : [' .. id .. '] --> ' ..
            text .. ' (' .. secondsFromNow .. ')'
    )

    local options = {
        alert = text,
        badge = 1,
    }

    if(self.deviceNotifications[id]) then
        print('cancelling device notification : ', self.deviceNotifications[id])
        system.cancelNotification( self.deviceNotifications[id] )
    end

    print('scheduling : ', id, secondsFromNow)
    self.deviceNotifications[id] = system.scheduleNotification(
        secondsFromNow,
        options
    )
    print('scheduled : ', self.deviceNotifications[id])

end

--------------------------------------------------------------------------------

function App:open()
    self.router = Router:new()
    self.game = Game:new()

    if(not GLOBALS.savedData) then
        self:initAppData()
    end

    self:initBackground();
    -- self.router:open(self.router.HOME)
    self.router:open(self.router.PLAYGROUND)
end

--------------------------------------------------------------------------------

function App:initAppData()

    GLOBALS.savedData = {
        user            = 'New player',
        fullGame        = GLOBALS.savedData ~= nil and GLOBALS.savedData.fullGame,
        requireTutorial = true
    }

    utils.saveTable(GLOBALS.savedData, 'savedData.json')

end

--------------------------------------------------------------------------------

function App:initBackground()
    display.setDefault( "background", 30/255, 30/255, 30/255 )
    utils.emptyGroup(self.bg)
    self.bg = display.newGroup()
    self.hud:insert(self.bg)
end

--------------------------------------------------------------------------------
-- Translations
--------------------------------------------------------------------------------

function T(enText)
    if(not translations[enText]) then
        print('Missing Translation : ' .. enText)
        return '&&&&&'
    end

    return translations[enText][LANG] or enText
end

function I(asset)
    return 'assets/images/bylang/'..LANG..'/'..asset
end

function translate(texts)
    return texts[LANG]
end

--------------------------------------------------------------------------------

return App
