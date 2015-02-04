--------------------------------------------------------------------------------
---
--------------------------------------------------------------------------------

local LevelBuilder = {}

local CENTER = 'room.center'

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

function LevelBuilder:reset()

    if(app.screen.level) then
        app.screen.level.removeDrag()
        display.remove(app.screen.level)
    end

    if(app.screen.grid) then
        Tools.hideSnapGrid()
    end

    app.screen.level = display.newGroup()
    app.screen:insert(app.screen.level)

    app.screen.level.base = display.newRect(
        app.screen.level,
        -4000, -4000,
        8000,
        8000
    )

    app.screen.level.base.anchorX = 0
    app.screen.level.base.anchorY = 0
    app.screen.level.base:setFillColor( 0.12 )

    touchController:addTap(app.screen.level, LevelBuilder.tapOnLevel)

    touchController:addDrag(app.screen.level)

    Tools.drawCenter()
    Tools.centerLevel()
end

--------------------------------------------------------------------------------

function LevelBuilder:dropItemOnGrid(event)
    print('dropItemOnGrid')
    local realX = event.x - app.screen.level.x - app.screen.x
    local realY = event.y - app.screen.level.y - app.screen.y
    local gridX = math.floor(realX/Room.WIDTH)
    local gridY = math.floor(realY/Room.HEIGHT)

    local jsonItem = {
        imagePath = Tools.imagePath(app.selectedItem.data),
        gridX     = gridX,
        gridY     = gridY
    }

    self:addToLevel(jsonItem)

end

--------------------------------------------------------------------------------

-- Floating item drop anywhere on scene
function LevelBuilder:dropItemOnScene(event)
    local item = display.newImage(
        app.screen.level,
        Tools.imagePath(app.selectedItem.data)
    )

    item.data = _.clone(app.selectedItem.data)
    self:addFloatingItem(item, event)
end

--------------------------------------------------------------------------------

--- load a json item
function LevelBuilder:loadJSONItem(jsonItem)

    local item = display.newImage(
        app.screen.level,
        Tools.imagePath(jsonItem)
    )

    item.data = jsonItem
    item.name = jsonItem.item

    if(app.screen.grid) then
        self:addToLevel(item)
    else
        self:addFloatingItem(item, jsonItem.x, jsonItem.y)
    end
end

--------------------------------------------------------------------------------

function LevelBuilder:import()
    print('------ Importing ' .. LEVELS_FOLDER .. IMPORT_LEVEL)
    self:reset()

    local level = {}
    local file = io.open( LEVELS_FOLDER .. IMPORT_LEVEL, "r" )
    if file then
        -- read all contents of file into a string
        local contents = file:read( "*a" )
        level = json.decode(contents);
        io.close( file )
    end

    if(level.grid) then
        Tools.toggleSnapGrid()
        for k,jsonItem in pairs(level.items) do
            self:loadJSONItem(jsonItem)
        end
    end
end

--------------------------------------------------------------------------------

function LevelBuilder:export()


    print('------ Exporting ')

    native.setActivityIndicator( true )

    ------------------------------------
    -- settings

    local level = {
        items = {},
        grid  = app.screen.grid ~= nil
    }

    ------------------------------------
    -- items

    for x,line in pairs(self.items) do
        for y,itemData in pairs(line) do
            print('exporting : ' .. itemData.item .. ' ' .. itemData.type ..
                    ' at [' .. itemData.x .. '][' .. itemData.y .. ']')

            level.items[#level.items+1] = itemData
        end
    end

    ------------------------------------

    local finalJSON = json.encode(level)

    ------------------------------------
    --  export

    if(SIMULATOR) then
        os.execute( "echo '" .. finalJSON .. "' > " ..
            LEVELS_FOLDER .. EXPORT_LEVEL
        )
    else
        self:deviceExport(finalJSON)
    end

    ------------------------------------
    -- release

    timer.performWithDelay(300, function()
        native.setActivityIndicator( false )
    end)
end

--------------------------------------------------------------------------------
-- private use
--------------------------------------------------------------------------------

--  jsonItem = {
--      gridX,
--      gridY,
--      imagePath
--  }

--
-- Tools.imagePath(app.selectedItem.data)

function LevelBuilder:addToLevel(jsonItem)

    local item = display.newImage(
        app.screen.level,
        jsonItem.imagePath
    )

    item.json = _.clone(jsonItem)

    self:addGridItem(
        item,
        jsonItem.gridX,
        jsonItem.gridY
    )

    utils.onTouch(item, function(event)
        self:tapOnItem(item, event)
    end)

    self:addDragToGridItem(item)

    Tools.selectItem(item)
end

--------------------------------------------------------------------------------

-- note : just selecting an item on the grid = remove + add it back + selection
function LevelBuilder:addDragToGridItem(item)
    local onDrop = function(event)
        print('-> onDrop')
        display.remove(item)
        self.items[item.data.x][item.data.y] = nil
        self.tapOnLevel(event)
    end

    local onDragStart = function(event)
        Tools.selectItem(item)
    end

    touchController:addDrag(item, {
        onDragStart = onDragStart,
        onDrop      = onDrop
    })
end

--------------------------------------------------------------------------------

-- tap on level
function LevelBuilder.tapOnLevel(event)
    print('tapOnLevel')
    if(app.selectedItem) then
        if(app.selectedItem.json.name == 'room') then
            if(app.screen.grid) then
                levelBuilder:dropItemOnGrid(event)
            else
                levelBuilder:dropItemOnScene(event)
            end
        end
    end
end

-- tap on level
function LevelBuilder:tapOnItem(item, event)
    print('tapOnItem')
    if(app.selectedItem) then
        if(app.selectedItem.json.name == 'room') then
            if(item.json.name == 'room') then
                Tools.selectItem(item)
            end
        else
            local direction = self:findDirectionOnRoom(item, event)

            if(direction ~= CENTER and app.selectedItem.json.name == 'wall') then
                local wall = display.newImage(
                    app.screen.level,
                    Tools.imagePath(app.selectedItem.data)
                )

                wall.rotation = (90 * (direction - 1))
                wall.x = item.x
                wall.y = item.y

                if(not item.children) then item.children = {} end
                item.children[#item.children + 1] = wall
            end
         end
    else
        print('nothing')
        Tools.selectItem(item)
    end
end

--------------------------------------------------------------------------------

function LevelBuilder:findDirectionOnRoom(item, event)
    local touchOnScreenX = event.x - app.screen.x
    local touchOnScreenY = event.y - app.screen.y

    local tileLeft = item.x - Room.WIDTH/2 + app.screen.level.x
    local tileTop  = item.y - Room.HEIGHT/2 + app.screen.level.y

    local touchOnTileX = touchOnScreenX - tileLeft
    local touchOnTileY = touchOnScreenY - tileTop

    local margin = 15
    if(touchOnTileX > margin
    and touchOnTileX < Room.WIDTH - margin
    and touchOnTileY < margin) then
        return Room.TOP
    end

    if(touchOnTileX > margin
    and touchOnTileX < Room.WIDTH - margin
    and touchOnTileY > Room.HEIGHT - margin) then
        return Room.BOTTOM
    end

    if(touchOnTileX < margin
    and touchOnTileY > margin
    and touchOnTileY < Room.HEIGHT - margin) then
        return Room.LEFT
    end

    if(touchOnTileX > Room.WIDTH - margin
    and touchOnTileY > margin
    and touchOnTileY < Room.HEIGHT - margin) then
        return Room.RIGHT
    end

    return CENTER
end

--------------------------------------------------------------------------------

function LevelBuilder:addGridItem(item, gridX, gridY)

    item.x = (gridX + 0.5) * Room.WIDTH
    item.y = (gridY + 0.5) * Room.HEIGHT

    _.extend(item.data, {
        x = gridX,
        y = gridY
    })

    if(not self.items[gridX]) then self.items[gridX] = {} end
    self.items[gridX][gridY] = item.data

end

--------------------------------------------------------------------------------

function LevelBuilder:addFloatingItem(item, event)
    item.x = event.x - app.screen.level.x - app.screen.x
    item.y = event.y - app.screen.level.y - app.screen.y

    _.extend(item.data, {
        x = item.x,
        y = item.y
    })

    self.items[#self.items + 1] = item.data
end

--------------------------------------------------------------------------------

--- saving on the device
function LevelBuilder:deviceExport(finalJSON)
    local path = system.pathForFile( 'output.json', system.DocumentsDirectory )
    local file = io.open(path, "w")

    if file then
        file:write( finalJSON )
        io.close( file )
    end
end

--------------------------------------------------------------------------------

return LevelBuilder
