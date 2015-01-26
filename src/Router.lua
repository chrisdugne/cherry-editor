--------------------------------------------------------------------------------

local Router = {}

--------------------------------------------------------------------------------

function Router:new()

    local router = {
        view = nil,

        HOME       = 'Home',
        PLAYGROUND = 'Playground'
    }

    setmetatable(router, { __index = Router })
    return router
end

--------------------------------------------------------------------------------

function Router:resetScreen()
    effectsManager.stop(true)
    utils.emptyGroup(app.hud)
end

--------------------------------------------------------------------------------

function Router:openView(id, class, params)
    self:resetScreen()
    analytics.pageview(id)
    storyboard.gotoScene( class, params )
    view = id
    print('Router : openView : ' .. id)
end

--------------------------------------------------------------------------------

function Router:open(id)
    self:openView(id, 'src.views.' .. id)
end

--------------------------------------------------------------------------------

return Router
