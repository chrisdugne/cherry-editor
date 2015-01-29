--------------------------------------------------------------------------------
---
--------------------------------------------------------------------------------

local LevelBuilder = {}

--------------------------------------------------------------------------------

function LevelBuilder:new()
    local lb = {
        items = {}
    }
    setmetatable(lb, { __index = LevelBuilder })
    return lb
end

--------------------------------------------------------------------------------
-- API
--------------------------------------------------------------------------------

function LevelBuilder:addItem(event)
    if(app.selectedItem) then
        local item = display.newImage(
            app.screen.level,
            app.selectedItem.imagePath
        )

        if(app.screen.grid) then
            self:addGridItem(item, event)
        else
            self:addFloatingItem(item, event)
        end
    end
end

function LevelBuilder:export()
    print('----- Export')
    utils.tprint(self.items)
end

--------------------------------------------------------------------------------
-- private use
--------------------------------------------------------------------------------

function LevelBuilder:addGridItem(item, event)
    local realX = event.x - app.screen.level.x - app.screen.x
    local realY = event.y - app.screen.level.y - app.screen.y
    local gridX = math.floor(realX/Room.WIDTH)
    local gridY = math.floor(realY/Room.HEIGHT)
    item.x = (gridX + 0.5) * Room.WIDTH
    item.y = (gridY + 0.5) * Room.HEIGHT
    item.data = {
        x = gridX,
        y = gridY,
        content = {}
    }

    if(not self.items[gridX]) then self.items[gridX] = {} end
    self.items[gridX][gridY] = item.data
end

--------------------------------------------------------------------------------

function LevelBuilder:addFloatingItem(item, event)
    item.x = event.x - app.screen.level.x - app.screen.x
    item.y = event.y - app.screen.level.y - app.screen.y
    item.data = {
        x = item.x,
        y = item.y,
        content = {}
    }

    self.items[#self.items + 1] = item.data
end

--------------------------------------------------------------------------------

return LevelBuilder
