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

    list('room')
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

end

--------------------------------------------------------------------------------

function list(name)
    local lfs = require "lfs"

    local baseDir = system.pathForFile('main.lua'):gsub("main.lua", "")
    local folder  = baseDir .. 'assets/images/game/' .. name

    for file in lfs.dir(folder) do
        if(utils.string.startsWith(file, name)) then
            local params    = utils.split(file, '.')
            local imagePath = 'assets/images/game/' .. name .. '/' .. file
            local item      = display.newImage(
                app.menu,
                imagePath,
                120, 50 + app.menu.numChildren * 120
            )

            item.imagePath = imagePath
            item.data = {
                item = params[1],
                type = params[2]
            }

            utils.onTouch(item, selectItem)

            app.menu:insert(item)
        end
    end
end

-------------------------------------

return Menu
