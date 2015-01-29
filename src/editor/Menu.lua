--------------------------------------------------------------------------------
---
--------------------------------------------------------------------------------

local Menu = {}

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

    list('rooms')
end

--------------------------------------------------------------------------------

function selectItem(item)

    local sameItem = app.selectedItem == item

    if(app.selectedItem) then
        app.selectedItem.strokeWidth = 0
        app.selectedItem = nil
    end

    if(not sameItem) then
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
            local imagePath = 'assets/images/' .. folder .. '/' .. file
            local item =  display.newImage(
                app.menu,
                imagePath,
                120, 50 + app.menu.numChildren * 120
            )

            item.imagePath = imagePath
            utils.onTouch(item, selectItem)

            app.menu:insert(item)
        end
    end
end

-------------------------------------

return Menu
