import "gameScene"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local fontPaths = {[gfx.font.kVariantNormal] = "fonts/GlitchGoblin"}
gfx.setFont(gfx.font.new("fonts/GlitchGoblin"))

local sceneList = {
                    ["images/cup"] = {35, 65, 150},
                    ["images/phone"] = {40, 60, 150} ,
                    ["images/tv"] = {42, 58, 150},
                    ["images/house"] = {44, 56, 175},
                    ["images/mountain"] = {45, 55, 200},
                    ["images/earth"] = {48, 54, 250}}
local iterator = 1

local sceneKeys = {"images/cup", "images/phone", "images/tv", "images/house", "images/mountain", "images/earth"}


class('SceneManager').extends()

function SceneManager:countElements(tbl)
    local count = 0
    for _ in pairs(tbl) do
        count = count + 1
    end
    return count
end

function SceneManager:init()
    self.transistionTime = 750
    self.transitioning = false
end

function SceneManager:switchScene(timeElapsed)
    if self.transitioning then
        return
    end
    self.transitioning = true
    self:startTransition(timeElapsed)
end

function SceneManager:loadNewScene(timeElapsed)
    self:cleanupScene(timeElapsed)
end

function SceneManager:startTransition(timeElapsed)
    local transitionTimer = self:wipeTransition(0, 400)
    transitionTimer.timerEndedCallback = function()
        self:loadNewScene(timeElapsed)
        transitionTimer = self:wipeTransition(400, 0)
        transitionTimer.timerEndedCallback = function()
            self.transitioning = false
        end
    end
end

function SceneManager:wipeTransition(startValue, endValue)
    local transitionSprite = self:createTransitionSprite()
    transitionSprite:setClipRect(0, 0, startValue, 240)

    local transistionTimer = pd.timer.new(self.transistionTime, startValue, endValue, pd.easingFunctions.inOutCubic)
    transistionTimer.updateCallback = function (timer)
        transitionSprite:setClipRect(0, 0, timer.value, 240)
    end
    return transistionTimer
end

function SceneManager:createTransitionSprite()
    local filledRect = gfx.image.new(400, 240, gfx.kColorBlack)
    local transitionSprite = gfx.sprite.new(filledRect)
    transitionSprite:moveTo(200, 120)
    transitionSprite:setZIndex(10000)
    transitionSprite:setIgnoresDrawOffset(true)
    transitionSprite:add()

    return transitionSprite
end

function SceneManager:getNextScene(timeElapsed)

    if iterator == 0 then
        GameTitleScene()
        iterator += 1
    elseif iterator <= self:countElements(sceneList) then
        local keys = {}
        for k in pairs(sceneList) do
            table.insert(keys, k)
        end
        table.sort(keys) -- Ensure consistent order if needed
        local sceneKey = sceneKeys[iterator]
        local minRange = sceneList[sceneKey][1]
        local maxRange = sceneList[sceneKey][2]
        local scoreGoal = sceneList[sceneKey][3]
        GameScene(sceneKey, minRange, maxRange, scoreGoal)
        iterator +=  1
    else
        GameOverScene(timeElapsed)
        iterator = 0
    end
end

function SceneManager:cleanupScene(timeElapsed)
    gfx.sprite.removeAll()
    self:removeAllTimers()
    gfx.setDrawOffset(0,0)
    self:getNextScene(timeElapsed)
end

function SceneManager:removeAllTimers()
    local allTimers = pd.timer.allTimers()
    for _, timer in ipairs(allTimers) do
        timer:remove()
    end
end
