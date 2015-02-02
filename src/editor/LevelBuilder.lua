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

    touchController:addTap(app.screen.level, function(event)
        if(app.screen.grid) then
            levelBuilder:dropItemOnGrid(event)
        else
            levelBuilder:dropItemOnScene(event)
        end

    end)

    touchController:addDrag(app.screen.level)

    Tools.drawCenter()
    Tools.centerLevel()
end

--------------------------------------------------------------------------------

function LevelBuilder:dropItemOnGrid(event)
    if(app.selectedItem) then
        local realX      = event.x - app.screen.level.x - app.screen.x
        local realY      = event.y - app.screen.level.y - app.screen.y
        local gridX      = math.floor(realX/Room.WIDTH)
        local gridY      = math.floor(realY/Room.HEIGHT)

        local item = display.newImage(
            app.screen.level,
            Tools.imagePath(app.selectedItem.data)
        )

        item.data = _.clone(app.selectedItem.data)

        self:addToLevel(item, gridX, gridY)

        Tools.selectItem(item)
    end
end

--------------------------------------------------------------------------------

-- Floating item drop anywhere on scene
function LevelBuilder:dropItemOnScene(event)
    if(app.selectedItem) then

        local item = display.newImage(
            app.screen.level,
            Tools.imagePath(app.selectedItem.data)
        )

        item.data = _.clone(app.selectedItem.data)
        self:addFloatingItem(item, event)
    end
end

--------------------------------------------------------------------------------

--- load a json item
function LevelBuilder:loadJSONItem(jsonItem)

    local item = display.newImage(
        app.screen.level,
        Tools.imagePath(jsonItem)
    )

    item.data = jsonItem

    if(app.screen.grid) then
        self:addToLevel(item)
    else
        self:addFloatingItem(item, jsonItem.x, jsonItem.y)
    end
end

--------------------------------------------------------------------------------

function LevelBuilder:addToLevel(item, gridX, gridY)
    self:addGridItem(
        item,
        gridX or item.data.x,
        gridY or item.data.y
    )

    self:addDragToGridItem(item)
    utils.onTouch(item, Tools.selectItem)
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

-- note : just selecting an item on the grid = remove + add it back + selection
function LevelBuilder:addDragToGridItem(item)
    local onDrop = function(event)
        display.remove(item)
        self.items[item.data.x][item.data.y] = nil
        self:dropItemOnGrid(event)
    end

    touchController:addDrag(item, onDrop)
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
