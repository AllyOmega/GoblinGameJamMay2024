import "CoreLibs/graphics"
import "CoreLibs/timer"
import "CoreLibs/ui"
import "CoreLibs/object"
import "CoreLibs/sprites"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Item').extends(gfx.sprite)

function Item:init(x, y, itemPath, goal)
    Item.super.init(self)

    score = 0
    self.itemImageTable = gfx.imagetable.new(itemPath)
    self.itemImages = {}

    for i = 1, #self.itemImageTable do
        self.itemImages[i] = self.itemImageTable[i]
    end

    self:setImage(self.itemImages[1])
    self:moveTo(x, y)
    self:add()  -- Add the sprite to the sprite system
    self:setScale(3)

    self.centerX = x
    self.centerY = y
    self.itemIter = 1
    self.scoreGoal = goal
    self.shakeTimer = pd.timer.new(50, function() self:shakeItem() end)
    self.shakeTimer.repeats = true
end

function Item:updateAnimationState(score)
    if score < self.scoreGoal/4 then
        self.itemIter = 1
    elseif score < self.scoreGoal*(2/3) then
        self.itemIter = 2
    elseif score < self.scoreGoal - 1 then
        self.itemIter = 3
    else
        self.itemIter = 4
    end

    self:setImage(self.itemImages[self.itemIter])

    -- Adjust the shaking speed based on itemIter
    if self.itemIter == 2 then
        self.shakeTimer.duration = 100  -- Shake every 100 ms
    elseif self.itemIter == 3 then
        self.shakeTimer.duration = 50  -- Shake every 50 ms
    else
        self.shakeTimer.duration = 5000  -- No shaking, set a large interval
    end
end

function Item:shakeItem()
    local shakeX, shakeY

    if self.itemIter == 2 then
        shakeX = math.random(-5, 5)
        shakeY = math.random(-2, 2)
    elseif self.itemIter == 3 then
        shakeX = math.random(-10, 10)
        shakeY = math.random(-4, 4)
    else
        shakeX = 0
        shakeY = 0
    end

    self:moveTo(self.centerX + shakeX, self.centerY + shakeY)
end
