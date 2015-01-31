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
    Screen.reset()

    if(app.screen.grid) then
        Tools.hideSnapGrid()
    end

    app.screen.level = display.newGroup()
    app.screen:insert(app.screen.level)

    Screen.touching()
    Screen.center()
end

--------------------------------------------------------------------------------

--- drop an item from the menu
function LevelBuilder:dropItem(event)
    if(app.selectedItem) then
        local item = display.newImage(
            app.screen.level,
            app.selectedItem.imagePath
        )

        item.data = app.selectedItem.data

        if(app.screen.grid) then
            local realX = event.x - app.screen.level.x - app.screen.x
            local realY = event.y - app.screen.level.y - app.screen.y
            local gridX = math.floor(realX/Room.WIDTH)
            local gridY = math.floor(realY/Room.HEIGHT)
            self:addGridItem(item, gridX, gridY)
        else
            self:addFloatingItem(item, event)
        end
    end
end

--------------------------------------------------------------------------------

--- load a json item
function LevelBuilder:loadJSONItem(jsonItem)
    local type = jsonItem.type
    local name = jsonItem.item
    local imagePath = 'assets/images/game/' ..
                         name .. '/' ..
                         name .. '.' .. type .. '.png'

    print(imagePath)

    local item = display.newImage(
        app.screen.level,
        imagePath
    )

    item.data = jsonItem

    if(app.screen.grid) then
        self:addGridItem(item, jsonItem.x, jsonItem.y)
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
            utils.tprint(itemData)
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

function LevelBuilder:addGridItem(item, gridX, gridY)
    print('adding on grid : ' .. item.data.item .. ' ' .. item.data.type ..
            ' at [' .. gridX .. '][' .. gridY .. ']')

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