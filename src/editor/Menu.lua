--------------------------------------------------------------------------------
---
--------------------------------------------------------------------------------

local Menu = {}

--------------------------------------------------------------------------------

Menu.prepare = function ()

    app.items = display.newGroup()

    ----------------------------------------------------------------------------

    app.itemsBounds = display.newRect(
        app.items,
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

    list('rooms')
end

--------------------------------------------------------------------------------

function selectItem(item)

    print('--------')
    print(app.selectedItem, item)
    local sameItem = app.selectedItem == item

    if(app.selectedItem) then
        print('yet selectedItem')
        app.selectedItem.strokeWidth = 0
        app.selectedItem = nil
    end

    if(not sameItem) then
        print('new selection')
        app.selectedItem = item
        item.strokeWidth = 4
        item:setStrokeColor( 25/255, 125/255, 25/255 )
    end

    print(app.selectedItem, item)
end

--------------------------------------------------------------------------------

function list(folder)
    local lfs = require "lfs"

    local baseDir = system.pathForFile('main.lua'):gsub("main.lua", "")
    local rooms   = baseDir .. 'assets/images/' .. folder

    for file in lfs.dir(rooms) do
        if(not utils.string.startsWith(file, '.')) then
            local item =  display.newImage(
                app.items,
                'assets/images/' .. folder .. '/' .. file,
                120, 50 + app.items.numChildren * 120
            )

            utils.onTouch(item, selectItem)

            app.items:insert(item)
        end
    end
end

-------------------------------------

return Menu
