--------------------------------------------------------------------------------
--[[
CBEffects Component: Presets

All the vent and field presets.
--]]
--------------------------------------------------------------------------------

local presets = {}

--------------------------------------------------------------------------------
-- Localize and Require
--------------------------------------------------------------------------------
local screen = require("CBEffects.cbe_core.misc.screen")
local lib_functions = require("CBEffects.cbe_core.misc.functions")

local math_random = math.random
local math_sin = math.sin
local display_newRect = display.newRect
local display_newCircle = display.newCircle
local display_newImageRect = display.newImageRect
local angleBetween = lib_functions.angleBetween

local burnColors = {{1, 0, 0}, {1, 1, 0}, {1, 1, 0}, {1, 1, 0}}

--------------------------------------------------------------------------------
-- Vent Presets
--------------------------------------------------------------------------------
presets.vents = {
    -- Default preset - no contents because the parameters for it are used as hard-coded defaults
    default = {physics = {}},

    ------------------------------------------------------------------------------
    -- Aurora
    ------------------------------------------------------------------------------
    aurora = {
        title = "aurora",
        positionType = "alongLine",
        x = 0, y = 0,
        point1 = {screen.width / 6, screen.centerY + (screen.height / 6)},
        point2 = {screen.width - (screen.width / 6), screen.centerY + (screen.height / 6)},
        build = function() return display_newImageRect("CBEffects/textures/glow.png", math_random(80, 150), math_random(160, 550)) end,
        color = {{0, 1, 0}, {0.588, 1, 0.588}},
        cycleColor = true,
        perEmit = 1,
        inTime = 500,
        outTime = 1500,
        lifeAlpha = 0.2,
        startAlpha = 0,
        onCreation = function(p) p.anchorY = 1 end,
        propertyTable = {blendMode = "add"},
        physics = {
            velocity = 1,
            autoAngle = false,
            angles = {0, 180},
            scaleRateY = 0.999
        }
    },

    ------------------------------------------------------------------------------
    -- Wisps
    ------------------------------------------------------------------------------

    wisps = {
        title = "wisps", 
        positionType = "inRadius", 
        x = screen.centerX, 
        y = screen.height - (screen.height / 7), 
        build = function() local s = math_random(20, 180) return display_newImageRect("CBEffects/textures/glow.png", s, s) end, 
        color={{1, 1, 0}, {0, 1, 0}}, 
        cycleColor = false, 
        curColor = 1, 
        emitDelay = 30, 
        perEmit = 1, 
        emissionNum = 0, 
        alpha = 1, 
        startAlpha = 0, 
        endAlpha = 0, 
        onCreation = function()end, 
        onDeath = function()end, 
        propertyTable = {blendMode = "add"}, 
        fadeInTime = 2500, 
        rectLeft = 0, 
        rectTop = 0, 
        rectWidth = screen.width, 
        rectHeight = screen.height, 
        onUpdate = function(particle,  vent)particle:applyForce((vent.x * 0.01) - (particle.x * 0.01),  0)end,
        physics = {
            xDamping = 0,
            yDamping = 0,
            velocity = 1.5, 
            angularVelocity = 0, 
            angularDamping = 0, 
            velFunction = function() return 0, 0 end, 
            autoAngle = true, 
            angles={{30, 150}}, 
            preCalculate = true, 
            sizeX = 0, 
            sizeY = 0, 
            minX = 0.1,
            minY = 0.1, 
            maxX = 100, 
            maxY = 100, 
            gravityX = 0, 
            gravityY=-0.02
        }, 
        rotateTowardVel = false, 
        towardVelOffset = 0
    },

    ------------------------------------------------------------------------------
    -- smallWisps = wisps : build change only : size
    ------------------------------------------------------------------------------

    smallwisps = {
        title = "smallwisps", 
        positionType = "inRadius", 
        x = screen.centerX, 
        y = screen.height - (screen.height / 7), 
        build = function() local s = math_random(50, 80) return display_newImageRect("CBEffects/textures/glow.png", s, s) end, 
        color={{1, 1, 0}, {0, 1, 0}}, 
        cycleColor = false, 
        curColor = 1, 
        emitDelay = 30, 
        perEmit = 1, 
        emissionNum = 0, 
        alpha = 1, 
        startAlpha = 0, 
        endAlpha = 0, 
        onCreation = function()end, 
        onDeath = function()end, 
        propertyTable = {blendMode = "add"}, 
        fadeInTime = 2500, 
        rectLeft = 0, 
        rectTop = 0, 
        rectWidth = screen.width, 
        rectHeight = screen.height, 
        onUpdate = function(particle,  vent)particle:applyForce((vent.x * 0.01) - (particle.x * 0.01),  0)end,
        physics = {
            xDamping = 0,
            yDamping = 0,
            velocity = 1.5, 
            angularVelocity = 0, 
            angularDamping = 0, 
            velFunction = function() return 0, 0 end, 
            autoAngle = true, 
            angles={{30, 150}}, 
            preCalculate = true, 
            sizeX = 0, 
            sizeY = 0, 
            minX = 0.1,
            minY = 0.1, 
            maxX = 100, 
            maxY = 100, 
            gravityX = 0, 
            gravityY=-0.02
        }, 
        rotateTowardVel = false, 
        towardVelOffset = 0
    },


    ------------------------------------------------------------------------------
    -- Line wisps
    ------------------------------------------------------------------------------
    
    linewisps = {
        title = "linewisps",
        positionType = "alongLine",
        build = function() local s = math_random(10, 20) return display_newImageRect("CBEffects/textures/glow.png", s, s) end, 
        x = 0, y = 0,
        emitDelay = 10,
        perEmit = 1,
        inTime = 250,
        outTime = 320,
        startAlpha = 1,
        propertyTable = {blendMode = "add"}, 
        physics = {
            xDamping = -1,
            yDamping = -1,
            velocity = 1.5, 
            angularVelocity = 0, 
            angularDamping = 0, 
            velFunction = function() return 0, 0 end, 
            autoAngle = true, 
            angles={{30, 50}}, 
            preCalculate = true, 
            sizeX = 0, 
            sizeY = 0, 
            minX = 0.1,
            minY = 0.1, 
            maxX = 10, 
            maxY = 10, 
            gravityX = -0.1, 
            gravityY=0.075
        }
    },

    ------------------------------------------------------------------------------
    -- Beams
    ------------------------------------------------------------------------------
    beams = {
        title = "beams",
        positionType = "inRadius",
        build = function() return display_newRect(0, 0, math_random(800), 20) end,
        color = {{1, 0, 0}, {0, 0, 1}},
        cycleColor = true,
        perEmit = 1,
        inTime = 300,
        outTime = 2000,
        lifeAlpha = 0.3,
        startAlpha = 0,
        onCreation = function(p, v) p.anchorX = 0 p.rotation = angleBetween(p.x, p.y, v.x, v.y, 90) end,
        physics = {
            velocity = 0,
            angularVelocity = 0.04,
        }
    },

    ------------------------------------------------------------------------------
    -- Burn
    ------------------------------------------------------------------------------
    burn = {
        title = "burn",
        positionType = "atPoint",
        build = function() local size = math_random(50, 150) return display_newImageRect("CBEffects/textures/glow.png", size, size) end,
        color = {{0, 0, 1}},
        emitDelay = 30,
        perEmit = 3,
        inTime = 500,
        outTime = 500,
        startAlpha = 0,
        onCreation = function(p) p.changeColor(burnColors[math_random(2)], 200) end,
        propertyTable = {blendMode = "add"},
        physics = {
            angles = {{80, 100}},
            scaleRateX = 0.98,
            scaleRateY = 0.98,
            gravityY = -0.05
        }
    },

    ------------------------------------------------------------------------------
    -- Circles
    ------------------------------------------------------------------------------
    circles = {
        title = "circles",
        positionType = "alongLine",
        x = 0, y = 0,
        point1 = {100, screen.height - 100},
        point2 = {screen.width - 100, screen.height - 100},
        build = function() return display_newCircle(0, 0, math_random(5, 30)) end,
        color = {{0, 0, 1}, {0.471, 0.471, 1}, {0, 0, 1}, {0.471, 0.471, 1}, {0, 0, 1}, {0.471, 0.471, 1}, {1, 0, 0}},
        emitDelay = 100,
        perEmit = 4,
        inTime = 300,
        outTime = 1000,
        startAlpha = 0,
        physics = {
            velocity = 5,
            angles = {{75, 105}},
            scaleRateX = 0.98,
            scaleRateY = 0.98
        }
    },

    ------------------------------------------------------------------------------
    -- Confetti
    ------------------------------------------------------------------------------
    confetti = {
        title = "confetti",
        positionType = "alongLine",
        x = 0, y = 0,
        point1 = {0, -10},
        point2 = {screen.width, -10},
        build = function() return display_newRect(0, 0, math_random(10, 15), math_random(10, 15)) end,
        color = {{1, 0, 0}, {0, 0, 1}, {1, 1, 0}, {0, 1, 0}},
        emitDelay = 100,
        perEmit = 2,
        inTime = 100,
        lifeTime = 1900,
        outTime = 50,
        startAlpha = 0,
        rotateTowardVel = true,
        physics = {
            velocity = 5,
            angles = {{200, 340}},
            gravityY = 0.1
        }
    },

    ------------------------------------------------------------------------------
    -- Embers
    ------------------------------------------------------------------------------
    embers = {
        title = "embers",
        positionType = "alongLine",
        x = 0, y = 0,
        point1 = {100, screen.height},
        point2 = {screen.width - 100, screen.height},
        build = function() local size = math_random(10, 20) return display_newImageRect("CBEffects/textures/glow.png", size, size) end,
        color = {{1, 1, 0}, {1, 1, 0}, {1, 1, 0}, {1, 1, 0}, {1, 0, 0}},
        emitDelay = 100,
        perEmit = 2,
        inTime = 300,
        lifeTime = 0,
        outTime = 1000,
        startAlpha = 0,
        propertyTable = {blendMode = "add"},
        physics = {
            velocity = 5,
            angles = {{75, 105}},
            gravityY = 0
        }
    },

    ------------------------------------------------------------------------------
    -- Evil
    ------------------------------------------------------------------------------
    evil = {
        title = "evil",
        positionType = "atPoint",
        build = function() local size = math_random(80, 120) return display_newImageRect("CBEffects/textures/glow.png", size, size) end,
        color = {{0.392, 0, 0.392}, {0, 0, 0.706}, {0.314, 0, 0.235}},
        emitDelay = 10,
        perEmit = 1,
        inTime = 1500,
        lifeTime = 0,
        outTime = 800,
        startAlpha = 0,
        propertyTable = {blendMode = "add"},
        physics = {
            velocity = 1.5,
            angles = {{0, 360}},
            scaleRateX = 0.997,
            scaleRateY = 0.997
        }
    },

    ------------------------------------------------------------------------------
    -- Flame
    ------------------------------------------------------------------------------
    flame = {
        title = "flame",
        positionType = "alongLine",
        x = 0, y = 0,
        point1 = {300, screen.height + 100},
        point2 = {screen.width - 300, screen.height + 100},
        build = function() local size = math_random(100, 300) return display_newImageRect("CBEffects/textures/cloud.png", size, size) end,
        color = {{1, 1, 0}, {1, 1, 0}, {1, 1, 0}, {1, 1, 0}, {0.784, 0.784, 0}, {0.784, 0.784, 0}, {1, 0.392, 0}},
        emitDelay = 100,
        perEmit = 2,
        inTime = 300,
        lifeTime = 500,
        outTime = 1000,
        startAlpha = 0,
        propertyTable = {blendMode = "screen"},
        physics = {
            xDamping = 0.2,
            yDamping = 0.2,
            velocity = 5,
            angularVelocity = 0.04,
            angles = {{75, 105}},
            scaleRateX = 1.01,
            scaleRateY = 1.01
        }
    },

    ------------------------------------------------------------------------------
    -- Fluid
    ------------------------------------------------------------------------------
    fluid = {
        title = "fluid",
        positionType = "inRect",
        x = 0, y = 0,
        rectLeft = screen.centerX * 0.5, rectTop = screen.centerY * 0.5,
        rectWidth = screen.centerX, rectHeight = screen.centerY,
        build = function() local size = math_random(100, 400) return display_newImageRect("CBEffects/textures/glow.png", size, size) end,
        color = {{1, 0, 1}, {1, 0, 0}, {1, 0, 0}, {0, 0, 1}},
        emitDelay = 30,
        perEmit = 1,
        inTime = 1500,
        lifeTime = 0,
        outTime = 800,
        startAlpha = 0,
        propertyTable = {blendMode = "add"},
        physics = {
            velocity = 0.5,
            angles = {{0, 360}}
        }
    },

    ------------------------------------------------------------------------------
    -- Fountain
    ------------------------------------------------------------------------------
    fountain = {
        title = "fountain",
        positionType = "atPoint",
        x = screen.centerX, y = screen.height * 0.75,
        build = function() local size = math_random(50, 80) return display_newImageRect("CBEffects/textures/glow.png", size, size) end,
        color = {{0, 0.855, 1}},
        inTime = 500,
        lifeTime = 0,
        outTime = 500,
        startAlpha = 0,
        propertyTable = {blendMode = "screen"},
        physics = {
            velocity = 12,
            angles = {{70, 110}},
            scaleRateX = 0.99,
            scaleRateY = 0.99,
            gravityY = 0.5
        }
    },

    ------------------------------------------------------------------------------
    -- Hyperspace
    ------------------------------------------------------------------------------
    hyperspace = {
        title = "hyperspace",
        positionType = "atPoint",
        x = screen.centerX, y = screen.centerY,
        build = function() return display_newImageRect("CBEffects/textures/glow.png", 10, 5) end,
        color = {{1}},
        emitDelay = 100,
        perEmit = 9,
        inTime = 500,
        lifeTime = 0,
        outTime = 1200,
        startAlpha = 0,
        onCreation = function(p) p.anchorX = 0 end,
        onUpdate = function(p) if p._numUpdates > 3 then p._cbe_reserved.rotateTowardVel = false end end,
        propertyTable = {blendMode = "screen"},
        rotateTowardVel = true,
        physics = {
            linearDamping = 0.9,
            velocity = 0.01,
            angles = {{1, 360}},
            scaleRateX = 1.06,
            maxScaleX = 100,
        }
    },

    ------------------------------------------------------------------------------
    -- Laser Gun
    ------------------------------------------------------------------------------
    lasergun = {
        title = "lasergun",
        positionType = "atPoint",
        x = 0, y = screen.centerY,
        build = function() return display_newImageRect("CBEffects/textures/glow.png", 150, 10) end,
        color = {{1, 1, 0}},
        emitDelay = 100,
        perEmit = 1,
        inTime = 120,
        lifeTime = 0,
        outTime = 800,
        startAlpha = 0,
        endAlpha = 1,
        physics = {
            velocity = 30,
            autoAngle = false,
            angles = {0}
        }
    },

    ------------------------------------------------------------------------------
    -- Rain
    ------------------------------------------------------------------------------
    rain = {
        title = "rain",
        positionType = "alongLine",
        x = 0, y = 0,
        point1 = {0, screen.top - 10},
        point2 = {screen.width * 1.14, screen.top - 10},
        build = function() return display_newRect(0, 0, math_random(2,4), math_random(6,25)) end,
        color = {{1}, {0.9, 0.9, 1}},
        perEmit = 1,
        outTime = 2000,
        startAlpha = 0,
        physics = {
            velocity = 10,
            angles = {{250, 260}}
        }
    },

    ------------------------------------------------------------------------------
    -- Smoke
    ------------------------------------------------------------------------------
    smoke = {
        title = "smoke",
        positionType = "alongLine",
        x = 0, y = 0,
        point1 = {200, screen.height - 100},
        point2 = {screen.width - 200, screen.height - 100},
        build = function() local size = math_random(200, 300) return display_newImageRect("CBEffects/textures/cloud.png", size, size) end,
        color = {{0.54}, {0.47}, {0.39}, {0.31}},
        emitDelay = 100,
        perEmit = 3,
        inTime = 700,
        outTime = 1200,
        startAlpha = 0,
        physics = {
            xDamping = 0.2,
            yDamping = 0.2,
            velocity = 6,
            angularVelocity = 0.04,
            angles = {{75, 105}},
            scaleRateX = 1.01,
            scaleRateY = 1.01
        }
    },

    ------------------------------------------------------------------------------
    -- Snow
    ------------------------------------------------------------------------------
    snow = {
        title = "snow",
        positionType = "alongLine",
        x = 0, y = 0,
        point1 = {0, screen.top - 10},
        point2 = {screen.width, screen.top - 10},
        build = function() local size = math_random(10, 40) return display_newImageRect("CBEffects/textures/glow.png", size, size) end,
        color = {{1}, {0.9, 0.9, 1}},
        perEmit = 1,
        inTime = 300,
        outTime = 2000,
        startAlpha = 0,
        lifeAlpha = 0.3,
        physics = {
            velFunction = function() return math_random(-1, 1), math_random(10) end,
            useVelFunction = true
        }
    },

    ------------------------------------------------------------------------------
    -- Sparks
    ------------------------------------------------------------------------------
    sparks = {
        title = "sparks",
        positionType = "inRadius",
        x = screen.centerX, y = screen.centerY,
        build = function() local size = math_random(10, 20) return display_newImageRect("CBEffects/textures/glow.png", size, size) end,
        color = {{1}, {0.9, 0.9, 1}},
        emitDelay = 1000,
        perEmit = 6,
        inTime = 300,
        outTime = 1000,
        startAlpha = 0,
        onEmitEnd = function(v) v.perEmit = math_random(5, 15) end,
        physics = {
            velocity = 5,
            gravityY = 0.5
        }
    },

    ------------------------------------------------------------------------------
    -- Steam
    ------------------------------------------------------------------------------
    steam = {
        title = "steam",
        positionType = "inRadius",
        x = screen.centerX, y = screen.height,
        build = function() local size = math_random(50, 100) return display_newImageRect("CBEffects/textures/cloud.png", size, size) end,
        color = {{1}, {0.9}, {0.78}},
        emitDelay = 50,
        perEmit = 10,
        inTime = 200,
        outTime = 800,
        startAlpha = 0,
        onEmitEnd = function(v) v.perEmit = math_random(5, 15) end,
        physics = {
            velocity = 12.5,
            angularVelocity = 0.04,
            angles = {{85, 95}},
            scaleRateX = 1.02,
            scaleRateY = 1.02
        }
    },


    ------------------------------------------------------------------------------
    -- Water
    ------------------------------------------------------------------------------
    water = {
        title = "water",
        positionType = "inRect",
        x = 0, y = 0,
        rectTop = screen.height / 3,
        rectWidth = screen.width,
        rectHeight = screen.height - (screen.height / 3),
        build = function() return display_newImageRect("CBEffects/textures/glow.png", 160, 20) end,
        color = {{1}, {0.8, 0.8, 0.8}},
        inTime = 500,
        outTime = 500,
        startAlpha = 0,
        onCreation = function(p)
            local a = (p.y - (screen.height / 3)) / 500 + 0.05
            if a <= 0.2 then
                p.isVisible = false
            else
                p.yScale = a
            end 
        end,
        onUpdate = function(p)
            local a = (p.y - (screen.height / 3)) / 500 + 0.05
            if a <= 0.2 then
                p.isVisible = false
            else
                p.yScale = a
            end 
        end,
        physics = {
            velocity = 1,
            angles = {{-20, 20}, {160, 200}}
        }
    },

    ------------------------------------------------------------------------------
    -- Waterfall
    ------------------------------------------------------------------------------
    waterfall = {
        title = "waterfall",
        positionType = "inRadius",
        x = screen.left, y = 100,
        build = function() local size = math_random(50, 100) return display_newImageRect("CBEffects/textures/cloud.png", size, size) end,
        color = {{1}, {0.8, 0.8, 1}, {0.9, 0.9, 1}},
        emitDelay = 50,
        perEmit = 3,
        inTime = 500,
        outTime = 800,
        startAlpha = 0,
        physics = {
            velocity = 3.5,
            autoAngle = false,
            gravityY = 0.5,
            scaleRateX = 1.02,
            scaleRateY = 1.04,
            angles = {0}
        }
    }
}


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- Field Presets
--------------------------------------------------------------------------------
presets.fields = {
    default = {}, 

    ------------------------------------------------------------------------------
    -- Out
    ------------------------------------------------------------------------------
    out = {
        title = "out",
        onCollision = function(p, f)
            p:applyParticleForce((p.x - f.x) * 0.01,  (p.y - f.y) * 0.01)
        end
    },

    ------------------------------------------------------------------------------
    -- Color Change
    ------------------------------------------------------------------------------
    colorchange = {
        title = "colorchange",
        singleEffect = true,
        onCollision = function(p, f)
            p.changeColor({0,  0,  1},  500,  0)
        end
    },

    ------------------------------------------------------------------------------
    -- Rotate
    ------------------------------------------------------------------------------
    rotate = {
        title = "rotate",
        onCollision = function(p, f)
            p:rotate(2)
        end
    },

    ------------------------------------------------------------------------------
    -- Stop
    ------------------------------------------------------------------------------
    stop = {
        title = "stop",
        onCollision = function(p)
            p:setVelocity(0, 0)
        end
    }
}

return presets