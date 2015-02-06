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

    local jsonItem = _.clone(app.selectedItem.json)
    _.extend(jsonItem, {
        x = gridX,
        y = gridY
    })

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
            self:addToLevel(jsonItem)
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
            print('exporting : ' .. itemData.name .. ' ' .. itemData.type ..
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

--  jsonItem = item.json = {
--      name,
--      type,
--      x,
--      y
--  }
function LevelBuilder:addToLevel(jsonItem, selection)

    local item = display.newImage(
        app.screen.level,
        Tools.imagePath(jsonItem)
    )

    item.json = jsonItem

    self:addGridItem(item)

    utils.onTouch(item, function(event)
        self:tapOnItem(item, event)
    end)

    self:addDragToGridItem(item)

    ------------------

    self:addChildren(item.json.children, item)

    ------------------

    if(selection) then
        Tools.selectItem(item)
    end
end

--------------------------------------------------------------------------------

function LevelBuilder:addChildren(jsonItems, parentItem)
    if(not jsonItems) then return end

    for k, child in pairs(jsonItems) do
        local item = display.newImage(
            app.screen.level,
            Tools.imagePath(child)
        )

        item.json = child
        item.x = parentItem.x
        item.y = parentItem.y

        if(child.direction) then
            item.rotation = (90 * (child.direction - 1))
        end

        if(not parentItem.children) then parentItem.children = {} end
        parentItem.children[#parentItem.children + 1] = item

        self:addChildren(child.children, child)
    end
end

--------------------------------------------------------------------------------

function LevelBuilder:deleteFromLevel(item)
    display.remove(item)
    self:deleteChildren(item.children)

    self.items[item.json.x][item.json.y] = nil
    item.json.children                   = nil
    item.json                            = nil
    item.children                        = nil
    item                                 = nil
end

function LevelBuilder:deleteChildren(items)
    if(not items) then return end

    for k, item in pairs(items) do
        display.remove(item)
        self:deleteChildren(item.children)
    end
end

--------------------------------------------------------------------------------

function LevelBuilder:redraw(item)
    local content = _.clone(item.json)
    self:deleteFromLevel(item)
    self:addToLevel(content)
end

--------------------------------------------------------------------------------

-- note : just selecting an item on the grid = remove + add it back + selection
function LevelBuilder:addDragToGridItem(item)
    local onDrop = function(event)
        print('-> onDrop')

        local realX = event.x - app.screen.level.x - app.screen.x
        local realY = event.y - app.screen.level.y - app.screen.y
        local gridX = math.floor(realX/Room.WIDTH)
        local gridY = math.floor(realY/Room.HEIGHT)

        local newItem = _.clone(item.json)
        self:deleteFromLevel(item)

        _.extend(newItem, {
            x = gridX,
            y = gridY
        })

        self:addToLevel(newItem, true)
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
    if(app.selectedItem) then
        if(app.selectedItem.json.name == 'room') then
            if(item.json.name == 'room') then
                Tools.selectItem(item)
            end
        else
            local direction = self:findDirectionOnRoom(item, event)

            if(app.selectedItem.json.name == 'wall') then
               self:addWall(item, direction)

            elseif(app.selectedItem.json.name == 'door') then
               self:addWall(item, direction)

            end
         end
    else
        print('nothing')
        Tools.selectItem(item)
    end
end
--------------------------------------------------------------------------------

function LevelBuilder:addWall(item, direction)
     if(direction ~= CENTER) then
        local jsonItem = _.clone(app.selectedItem.json)
        _.extend(jsonItem, {
            direction = direction
        })

        if(not item.json.children) then item.json.children = {} end
        item.json.children[#item.json.children + 1] = jsonItem

        self:redraw(item)
    else
        print('no wall on center')
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

function LevelBuilder:addGridItem(item)

    local gridX = item.json.x
    local gridY = item.json.y

    item.x = (gridX + 0.5) * Room.WIDTH
    item.y = (gridY + 0.5) * Room.HEIGHT

    _.extend(item.json, {
        x = gridX,
        y = gridY
    })

    if(not self.items[gridX]) then self.items[gridX] = {} end
    self.items[gridX][gridY] = item.json

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
