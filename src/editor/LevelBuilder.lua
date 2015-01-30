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

        item.data = app.selectedItem.data

        if(app.screen.grid) then
            self:addGridItem(item, event)
        else
            self:addFloatingItem(item, event)
        end
    end
end

--------------------------------------------------------------------------------

function LevelBuilder:import()
    print('------ Importing ' .. LEVELS_FOLDER .. IMPORT_LEVEL)
    local file = io.open( LEVELS_FOLDER .. IMPORT_LEVEL, "r" )
    if file then
        -- read all contents of file into a string
        local contents = file:read( "*a" )
        print(contents)
        local myTable = json.decode(contents);
        utils.tprint(myTable)
        io.close( file )
    end

    print('---------')
end

--------------------------------------------------------------------------------

function LevelBuilder:export()

    native.setActivityIndicator( true )

    local t = {}
    for x,line in pairs(self.items) do
        for y,item in pairs(line) do
            t[#t+1] = item
        end
    end

    local finalJSON = json.encode(t)
    print(finalJSON)

    if(SIMULATOR) then
        os.execute( "echo '" .. finalJSON .. "' > " ..
            LEVELS_FOLDER .. EXPORT_LEVEL
        )
    else
        self:deviceExport(finalJSON)
    end

    timer.performWithDelay(300, function()
        native.setActivityIndicator( false )
    end)
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
