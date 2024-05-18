
local pd <const> = playdate
local gfx <const> = pd.graphics


class('Ball').extends(gfx.sprite)

local ballImageTable = gfx.imagetable.new('images/ball')

local ballImages = {}

for i = 1, #ballImageTable do 
    ballImages[i] = ballImageTable[i]
end

function Cloud:init(x,y, m)
    Cloud.super.init(self)
    self:setImage(cloudImages[math.random(1,4)])
    
    if m == 0 then
        self:setZIndex(800)
    else
        self:setZIndex(32764)
    end
    self:setCenter(0,0)
    self:setCollideRect(0,0,12,16)
    self:moveTo(x,y)
    self:add()
    self.randGrow = 1+(math.random(1,10)/1000)
end

local setImage = gfx.sprite.setImage
local getImage = gfx.imagetable.getImage



-- function Cloud:update()
--     if cloudTimer.frame % 20 == 0 then
--         setImage(self, cloudImages[math.random(1,4)])
--     end
-- end
