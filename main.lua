--------------------------------------------------------------------------------
--
-- main.lua
--
--------------------------------------------------------------------------------
--- Corona's libraries
json                = require 'json'
storyboard          = require 'storyboard'

---- Additional libs

_                   = require 'src.libs.Underscore'
utils               = require 'src.libs.Utils'

--------------------------------------------------------------------------------
---- App packages

App                 = require 'src.App'
Screen              = require 'src.editor.Screen'
Menu                = require 'src.editor.Menu'
Toolbar             = require 'src.editor.Toolbar'
Tools               = require 'src.editor.Tools'
LevelBuilder        = require 'src.editor.LevelBuilder'
effectsManager      = require 'src.game.engine.EffectsManager'
touchController     = require 'src.game.engine.TouchController'

--------------------------------------------------------------------------------

levelBuilder = LevelBuilder:new()

app = App:new()
app:start()
