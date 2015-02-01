--------------------------------------------------------------------------------

local TouchController = {}

--------------------------------------------------------------------------------
-- API
--------------------------------------------------------------------------------

function TouchController:stopPropagation (listener, content)
    listener:addEventListener( 'touch', function(event)
        return true
    end)
end

function TouchController:addDrag (o)
    local onEvent = function(event)
        drag(o, event)
    end

    o:addEventListener( 'touch', onEvent )

    o.removeDrag = function()
        o:removeEventListener( 'touch', onEvent )
    end
end

function TouchController:addTap (listener, action)
    listener:addEventListener( 'touch', function(event)
        tap(event, action)
    end)
end

--------------------------------------------------------------------------------

function drag (o, event)
    if event.phase == 'began' then
        display.getCurrentStage():setFocus( o )
        o.markX = o.x
        o.markY = o.y

    elseif event.phase == 'moved' then
        o.x = (event.x - event.xStart) + o.markX
        o.y = (event.y - event.yStart) + o.markY
        o.moving = true

    elseif event.phase == 'ended' or event.phase == 'cancelled' then
        display.getCurrentStage():setFocus( nil )
        o.moving = false

    end

end

--------------------------------------------------------------------------------

function tap (event, action)

    if event.phase == 'began' then
        event.target.startTap = system.getTimer()

    elseif (event.phase == 'ended' or event.phase == 'cancelled') then
        if(system.getTimer() - event.target.startTap < 100) then
            action(event)
        end
    end

end

--------------------------------------------------------------------------------

return TouchController
