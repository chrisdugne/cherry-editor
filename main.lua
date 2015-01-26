--------------------------------------------------------------------------------
--
-- main.lua
--
--------------------------------------------------------------------------------
--- Corona's libraries
json                = require 'json'
storyboard          = require 'storyboard'

---- Additional libs

CBE                 = require 'CBEffects.Library'
_                   = require 'src.libs.Underscore'
utils               = require 'src.libs.Utils'

--------------------------------------------------------------------------------
---- App packages

App                 = require 'src.App'
effectsManager      = require 'src.game.engine.EffectsManager'

--------------------------------------------------------------------------------

app = App:new()
app:start()
