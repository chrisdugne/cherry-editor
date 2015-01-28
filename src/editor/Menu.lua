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

function list(folder)
    local lfs = require "lfs"

    local baseDir = system.pathForFile('main.lua'):gsub("main.lua", "")
    local rooms   = baseDir .. 'assets/images/' .. folder

    local verticalPosition = 1
    for file in lfs.dir(rooms) do
        if(not utils.string.startsWith(file, '.')) then
            local item =  display.newImage(
                app.items,
                'assets/images/' .. folder .. '/' .. file,
                120, 50 + verticalPosition * 120
            )

            verticalPosition = verticalPosition + 1
            app.items:insert(item)
        end
    end
end

-------------------------------------

return Menu
