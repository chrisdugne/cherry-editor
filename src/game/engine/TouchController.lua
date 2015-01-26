---------------------------------------------------------------------

module(..., package.seeall)

---------------------------------------------------------------------

local NONE            = 0
local DRAGGING_SCREEN = 100
local DRAGGING_TILE   = 101

---------------------------------------------------------------------

local currentState = NONE

local xStart = 0
local yStart = 0
local lastX  = 0
local lastY  = 0

---------------------------------------------------------------------

function start()
    display.getCurrentStage():addEventListener( "touch", touchScreen )
end

function stop()
    display.getCurrentStage():removeEventListener( "touch", touchScreen )
    display.getCurrentStage():setFocus( nil )
end

---------------------------------------------------------------------

function touchScreen( event )

    if(currentState == DRAGGING_TILE) then return end

    -----------------------------

    dragScreen(event)

    -----------------------------

    if event.phase == "began" then

    elseif event.phase == "ended" or event.phase == "cancelled" then
        display.getCurrentStage():setFocus( nil )

    end

    return false
end


function setState(state, toApply)

    if(currentState ~= state) then
        xStart, yStart = lastX, lastY
        --        previousState = currentState
        currentState = state

        if(toApply ~= nil) then
            toApply()
        end
    end

end

---------------------------------------------------------------------


function dragScreen( event )

    if event.phase == "began" then
        app.screen.level.markX = app.screen.level.x    -- store x location of object
        app.screen.level.markY = app.screen.level.y    -- store y location of object
        setState(DRAGGING_SCREEN)

    elseif event.phase == "moved" and currentState == DRAGGING_SCREEN then

        local x = ((event.x - event.xStart) + app.screen.level.markX)
        local y = ((event.y - event.yStart) + app.screen.level.markY)

        app.screen.level.x = x
        app.screen.level.y = y

    elseif event.phase == "ended" or event.phase == "cancelled" then
        setState(NONE)

    end

    return true
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
