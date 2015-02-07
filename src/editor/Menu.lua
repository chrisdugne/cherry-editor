--------------------------------------------------------------------------------
---
--------------------------------------------------------------------------------

local Menu = {}
local items = {'room', 'door', 'wall', 'frog'}
local currentList = 0

--------------------------------------------------------------------------------

function Menu:prepare ()

    app.menu = display.newGroup()
    touchController:stopPropagation(app.menu)

    ----------------------------------------------------------------------------

    app.itemsBounds = display.newRect(
        app.menu,
        0,
        TOOLBAR_HEIGHT + 1, -- note : +1 -> strokeWidth
        ITEMS_WIDTH,
        ITEMS_HEIGHT
    )

    app.itemsBounds.anchorX = 0
    app.itemsBounds.anchorY = 0

    app.itemsBounds.strokeWidth = 1
    app.itemsBounds:setFillColor( 0.12 )
    app.itemsBounds:setStrokeColor( 225/255, 225/255, 225/255 )

    ----------------------------------------------------------------------------

    buildArrows()

    ----------------------------------------------------------------------------

    nextList()
end

--------------------------------------------------------------------------------

function buildArrows(name)
    app.menu.arrows = display.newGroup()
    app.menu.arrows.x = 0
    app.menu.arrows.y = display.contentHeight
    app.menu.arrows.width = ITEMS_WIDTH
    app.menu.arrows.height = TOOLBAR_HEIGHT

    app.menu.arrows.anchorX = 0
    app.menu.arrows.anchorY = 1

    app.menu.arrows.bounds = display.newRect(
        app.menu.arrows,
        0, 0,
        ITEMS_WIDTH,
        TOOLBAR_HEIGHT
    )

    app.menu.arrows.bounds.anchorX = 0
    app.menu.arrows.bounds.anchorY = 1
    app.menu.arrows.bounds.strokeWidth = 1
    app.menu.arrows.bounds:setFillColor( 0.12 )
    app.menu.arrows.bounds:setStrokeColor( 225/255, 225/255, 225/255 )


    local left = display.newImage(
        app.menu.arrows,
        'assets/images/editor/noun_44977_cc.png',
        80, -app.menu.arrows.height/2
    )

    local right = display.newImage(
        app.menu.arrows,
        'assets/images/editor/noun_44977_cc.png',
        160, -app.menu.arrows.height/2
    )

    right.rotation = 180

    utils.onTouch(left, function()
        previousList()
    end)

    utils.onTouch(right, function()
        nextList()
    end)
end

--------------------------------------------------------------------------------

function previousList()
    currentList = currentList - 1
    if(currentList == 0) then currentList = #items end
    list(items[currentList])
end

function nextList()
    currentList = currentList + 1
    if(currentList == (#items + 1)) then currentList = 1 end
    list(items[currentList])
end

--------------------------------------------------------------------------------

function list(name)

    if(app.menu.list) then
        display.remove(app.menu.list)
    end

    app.menu.list = display.newGroup()
    app.menu:insert(app.menu.list)
    app.menu.list.y = TOOLBAR_HEIGHT + 50

    local lfs = require "lfs"

    local baseDir = system.pathForFile('main.lua'):gsub("main.lua", "")
    local folder  = baseDir .. 'assets/images/game/' .. name

    for file in lfs.dir(folder) do
        local isSheet = string.find(file, 'sheet')
        local isItem = utils.string.startsWith(file, name)

        if(isItem and not isSheet) then
            local params = utils.split(file, '.')
            local item   = display.newImage(
                app.menu.list,
                'assets/images/game/' .. name .. '/' .. file,
                120, 50 + app.menu.list.numChildren * 120
            )

            item.json = {
                name = name,
                type = params[2]
            }

            utils.onTouch(item, function(event)
                Tools.selectItem(item)
            end)
        end
    end
end

-------------------------------------

return Menu
