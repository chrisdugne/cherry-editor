-----------------------------------------------------------------------------------------

ScoreManager = {}    

-----------------------------------------------------------------------------------------

function ScoreManager:new()  

    local object = {
        score     = {}
    }

    setmetatable(object, { __index = ScoreManager })
    return object
end

--------------------------------------------------------------------------------------------------------------------------
--- RESULT BOARD
--------------------------------------------------------------------------------------------------------------------------

function ScoreManager:displayScore()

    local top = display.newRect(game.hud, display.contentWidth/2, -display.contentHeight/5, display.contentWidth, display.contentHeight/5)
    top.alpha = 0
    top:setFillColor(0)

    local bottom = display.newRect(game.hud, display.contentWidth/2, display.contentHeight, display.contentWidth, display.contentHeight/5)
    bottom.alpha = 0
    bottom:setFillColor(0)

    local board = display.newRoundedRect(game.hud, 0, 0, display.contentWidth/2, display.contentHeight/2, 20)
    board.x = display.contentWidth/2
    board.y = display.contentHeight/2
    board.alpha = 0
    board:setFillColor(0)

    transition.to( top, { time=800, alpha=1, y = top.contentHeight/2 })
    transition.to( bottom, { time=800, alpha=1, y = display.contentHeight - top.contentHeight/2 })  
    transition.to( board, { time=800, alpha=0.6, onComplete= function() self:fillBoard() end})  

end

----------------------------------

function ScoreManager:fillBoard()
end

-----------------------------------------------------------------------------------------

return ScoreManager