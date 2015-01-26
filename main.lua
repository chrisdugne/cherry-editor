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
analytics           = require 'src.libs.google.Analytics'

--------------------------------------------------------------------------------
---- App packages

App                 = require 'src.App'
Router              = require 'src.Router'
Game                = require 'src.game.engine.Game'

effectsManager      = require 'src.game.engine.EffectsManager'

--------------------------------------------------------------------------------
---- Models

Room                = require 'src.game.models.Room'
Door                = require 'src.game.models.Door'
Wall                = require 'src.game.models.Wall'
Frog                = require 'src.game.models.Frog'
Trigger             = require 'src.game.models.Trigger'

--------------------------------------------------------------------------------
---- Levels

LevelTest1          = require 'src.game.levels.LevelTest1'
Level01             = require 'src.game.levels.level01'
Level11             = require 'src.game.levels.level11'

--------------------------------------------------------------------------------

app = App:new()
app:start()
