---------------------------------------------------------------------

module(..., package.seeall)

---------------------------------------------------------------------

function start()
    display.getCurrentStage():addEventListener( "touch", touchScreen )

    rightTouch  = false
    leftTouch   = false
end

function stop()
    display.getCurrentStage():removeEventListener( "touch", touchScreen )
    display.getCurrentStage():setFocus( nil )
end

---------------------------------------------------------------------

function touchScreen( event )

    if event.phase == "began" then


    elseif event.phase == "ended" or event.phase == "cancelled" then
        display.getCurrentStage():setFocus( nil )
        
    end

    return false
end

---------------------------------------------------------------------

function drag( o, event )

    if event.phase == "began" then
        display.getCurrentStage():setFocus( o )
        o.moving = true
        o.markX = o.x
        o.markY = o.y

    elseif event.phase == "moved" and o.moving then
        o.x = (event.x - event.xStart) + o.markX
        o.y = (event.y - event.yStart) + o.markY

    elseif event.phase == "ended" or event.phase == "cancelled" then
        display.getCurrentStage():setFocus( nil )
        o.moving = false

    end

    return true
end