--
-- local Frog = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", Frog:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={Frog:getFrameIndex("sprite")}} )
--

local Frog = {}

Frog.sheet =
{
    frames = {
       {
          y = 0,
          x = 0,
          height = 94,
          width = 108,
       },
       {
          y = 0,
          x = 108,
          height = 94,
          width = 108,
       },
       {
          y = 0,
          x = 216,
          height = 94,
          width = 108,
       },
       {
          y = 0,
          x = 324,
          height = 94,
          width = 108,
       },
       {
          y = 0,
          x = 432,
          height = 94,
          width = 108,
       },
       {
          y = 0,
          x = 540,
          height = 94,
          width = 108,
       },
       {
          y = 0,
          x = 648,
          height = 94,
          width = 108,
       },
       {
          y = 0,
          x = 756,
          height = 94,
          width = 108,
       },
       {
          y = 94,
          x = 0,
          height = 94,
          width = 108,
       },
       {
          y = 94,
          x = 108,
          height = 94,
          width = 108,
       },
       {
          y = 94,
          x = 216,
          height = 94,
          width = 108,
       },
       {
          y = 94,
          x = 324,
          height = 94,
          width = 108,
       },
       {
          y = 94,
          x = 432,
          height = 94,
          width = 108,
       },
       {
          y = 94,
          x = 540,
          height = 94,
          width = 108,
       },
       {
          y = 94,
          x = 648,
          height = 94,
          width = 108,
       },
       {
          y = 94,
          x = 756,
          height = 94,
          width = 108,
       },
       {
          y = 188,
          x = 0,
          height = 94,
          width = 108,
       },
       {
          y = 188,
          x = 108,
          height = 94,
          width = 108,
       },
       {
          y = 188,
          x = 216,
          height = 94,
          width = 108,
       },
       {
          y = 188,
          x = 324,
          height = 94,
          width = 108,
       },
       {
          y = 188,
          x = 432,
          height = 94,
          width = 108,
       },
       {
          y = 188,
          x = 540,
          height = 94,
          width = 108,
       },
       {
          y = 188,
          x = 648,
          height = 94,
          width = 108,
       },
       {
          y = 188,
          x = 756,
          height = 94,
          width = 108,
       },
    },

    sheetContentWidth = 864,
    sheetContentHeight = 282
}

Frog.frameIndex =
{
    ["1"]  = 1,
    ["2"]  = 2,
    ["3"]  = 3,
    ["4"]  = 4,
    ["5"]  = 5,
    ["6"]  = 6,
    ["7"]  = 7,
    ["8"]  = 8,
    ["10"] = 10,
    ["11"] = 11,
    ["12"] = 12,
    ["13"] = 13,
    ["14"] = 14,
    ["15"] = 15,
    ["16"] = 16,
    ["17"] = 17,
    ["18"] = 18,
    ["19"] = 19,
    ["20"] = 20,
    ["21"] = 21,
    ["22"] = 22,
    ["23"] = 23,
    ["24"] = 24
}

function Frog:newSequence()
    return {
       name = "turn",  --name of animation sequence
       start = 1,  --starting frame index
       count = 24,  --total number of frames to animate consecutively before stopping or looping
       time = 1000,  --optional, in milliseconds; if not supplied, the sprite is frame-based
       loopCount = 0,  --optional. 0 (default) repeats forever; a positive integer specifies the number of loops
       loopDirection = "forward"  --optional, either "forward" (default) or "bounce" which will play forward then backwards through the sequence of frames
   }  --if defining more sequences, place a comma here and proceed to the next sequence sub-table
end

function Frog:getFrameIndex(name)
    return self.frameIndex[name];
end

return Frog
