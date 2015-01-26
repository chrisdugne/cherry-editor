--
-- local Trigger1 = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", Trigger1:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={Trigger1:getFrameIndex("sprite")}} )
--

local Trigger1 = {}

Trigger1.sheet =
{
    frames = {

       ---------
       -- switch-on

       {
          y = 0,
          x = 0,
          height = 42,
          width = 33,
       },
       {
          y = 0,
          x = 33,
          height = 42,
          width = 33,
       },
       {
          y = 0,
          x = 66,
          height = 42,
          width = 33,
       },
       {
          y = 0,
          x = 99,
          height = 42,
          width = 33,
       },
       {
          y = 0,
          x = 132,
          height = 42,
          width = 33,
       },
       {
          y = 0,
          x = 165,
          height = 42,
          width = 33,
       },
       {
          y = 0,
          x = 198,
          height = 42,
          width = 33,
       },

       ---------
       -- switch-off

       {
          y = 0,
          x = 198,
          height = 42,
          width = 33,
       },
       {
          y = 0,
          x = 165,
          height = 42,
          width = 33,
       },
       {
          y = 0,
          x = 132,
          height = 42,
          width = 33,
       },
       {
          y = 0,
          x = 99,
          height = 42,
          width = 33,
       },
       {
          y = 0,
          x = 66,
          height = 42,
          width = 33,
       },
       {
          y = 0,
          x = 33,
          height = 42,
          width = 33,
       },
       {
          y = 0,
          x = 0,
          height = 42,
          width = 33,
       }

    },

    sheetContentWidth = 231,
    sheetContentHeight = 42
}

Trigger1.steps =
{
    ["off"] = 1,
    ["on"]  = 8
}

function Trigger1:newSequence()
    return {
      {
         name = "switch-on",  --name of animation sequence
         start = 1,  --starting frame index
         count = 7,  --total number of frames to animate consecutively before stopping or looping
         time = 350,  --optional, in milliseconds; if not supplied, the sprite is frame-based
         loopCount = 1,  --optional. 0 (default) repeats forever; a positive integer specifies the number of loops
         loopDirection = "forward"  --optional, either "forward" (default) or "bounce" which will play forward then backwards through the sequence of frames
      },
      {
         name = "switch-off",  --name of animation sequence
         start = 8,  --starting frame index
         count = 7,  --total number of frames to animate consecutively before stopping or looping
         time = 350,  --optional, in milliseconds; if not supplied, the sprite is frame-based
         loopCount = 1,  --optional. 0 (default) repeats forever; a positive integer specifies the number of loops
         loopDirection = "forward"  --optional, either "forward" (default) or "bounce" which will play forward then backwards through the sequence of frames
      }
    }
end

function Trigger1:frame(name)
    return self.steps[name];
end

return Trigger1
