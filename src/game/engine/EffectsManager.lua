--------------------------------------------------------------------------------

module(..., package.seeall)

--------------------------------------------------------------------------------

effects         = {}
nbDestroyed     = 0
nbRunning       = 0

-------------------------------------

function start(refresh)
    if(refresh) then
        Runtime:addEventListener( "enterFrame", refreshEffects )
    else
        startAllEffects()
    end
end

function stop(now)
    Runtime:removeEventListener( "enterFrame", refreshEffects )

    if(effects) then
        for i=1,#effects do
            destroyEffect(effects[i], now)
        end
    end

    effects     = {}
    nbDestroyed = 0
    nbRunning   = 0
end

function restart()
    stop(true)
    start()
end

--------------------------------------------------------------------------------
-- for static views : no refresh required
function startAllEffects()
    if(effects) then
        for i=1,#effects do
            startEffect(effects[i])
        end
    end
end

--------------------------------------------------------------------------------

function registerNewEffect( effect )
    effect.num = #effects+1
    effects[effect.num] = effect
end

--------------------------------------------------------------------------------

function startEffect( effect )
    effect:startMaster()
    effect.started = true

    --- debug
    nbRunning = nbRunning + 1
end

--------------------------------------------------------------------------------

function stopEffect( effect )
    effect:stopMaster()
    effect.started = false

    --- debug
    nbRunning = nbRunning - 1
end

--------------------------------------------------------------------------------

function destroyEffect( effect, now )
    if(not effect.beingDestroyed and effect.num) then
        effect.beingDestroyed = true

        if(not now and effect.body) then
            utils.destroyFromDisplay(effect.body)
        end

        if(effect.started) then
            stopEffect(effect)
        end

        if(now) then
            effect:destroyMaster()
            effect = nil
        else
            timer.performWithDelay(3000, function()
                if(effect.num) then -- else detruit entre temps
                    effect:destroyMaster()
                end
            end)
        end

        -- Probleme : supprimer les nums decale en meme temps les nouveaux cest pourri
        --    table.remove(effects, effect.num)
        --
        --    for i=effect.num, #effects do
        --        effects[i].num = effects[i].num - 1
        --    end
        -- TODO vider la liste des effects nil !

        --- debug
        nbDestroyed = nbDestroyed + 1

        return true
    else
        return false
    end

end

--------------------------------------------------------------------------------

function destroyObjectWithEffect(body)
    if(body.effect) then
        return destroyEffect(body.effect)
    else
        return false
    end
end

--------------------------------------------------------------------------------
--- CHECK level effects in screen
--------------------------------------------------------------------------------
--
-- An effect on hud has no body => onScreen
--
-- An effect on camera must have a body (sensor (energy or trigger))
--     -> wake up if onScreen only
--
-- An effect not static has its coordinates refreshed
--
--------------------------------------------------------------------------------

function refreshEffects()

    if(effects) then
        for i=1,#effects do
            local effect = effects[i]

            if(not effect.beingDestroyed and effect.num) then -- else passed throug destroyMaster
                local isOnscreen = not effect.body -- si il n y a pas de body cest un simple effet visuel : onScreen (exemple drawFollow)

                if(game.state == game.RUNNING) then
                    if(not effect.static) then
                        refreshEffectsCoordinates(effect)
                    end

                    if(effect.isRope) then
                        refreshRopeCoordinates(effect)
                    end

                    if( effect.body
                    and effect.body.x
                    and effect.body.x > (-game.camera.x - 50)/game.zoom
                    and effect.body.x < (display.contentWidth - game.camera.x + 50)/game.zoom
                    and effect.body.y > (-game.camera.y - 50)/game.zoom
                    and effect.body.y < (display.contentHeight - game.camera.y + 50)/game.zoom) then
                        isOnscreen = true
                    end
                end

                if(isOnscreen) then
                    if(not effect.started) then
                        startEffect(effect)
                    end
                elseif(effect.started) then
                    stopEffect(effect)
                end
            end
        end
    end
end

function refreshEffectsCoordinates(effect)
    if(effect.body and effect.body.x and effect.body.y) then
        effect:get("light").x = effect.body.x
        effect:get("light").y = effect.body.y
    end
end

--------------------------------------------------------------------------------
--- Menu Atmospheres
--------------------------------------------------------------------------------

function atmosphere(x, y, scale)

    local light = CBE.VentGroup{
        {
            title       = "light",
            preset      = "wisps",
            color       = {
                {65/255,5/255,2/255},
                {55/255,55/255,20/255},
                {15/255,15/255,120/255}
            },
            x           = x,
            y           = y,
            perEmit     = math.random(2,5),
            emissionNum = 0,
            emitDelay   = 320,
            lifeSpan    = 1800,
            fadeInTime  = 1800,
            scale       = 0.5*scale,
            physics     = {
                gravityY = 0.025,
            }
        }
    }

    light.static = true
    registerNewEffect(light)
    app.hud:insert(light:get("light").content)

end

--------------------------------------------------------------------------------
