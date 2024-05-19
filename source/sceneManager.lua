import "gameScene"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local fontPaths = {[gfx.font.kVariantNormal] = "fonts/GlitchGoblin"}
gfx.setFont(gfx.font.new("fonts/GlitchGoblin"))

local sceneList = {"images/cup", 
                    "images/phone", 
                    "images/tv", 
                    "images/house", 
                    "images/mountain", 
                    "images/earth" }
local iterator = 1
local timeTotal = 0


class('SceneManager').extends()

function SceneManager:init()
    self.transistionTime = 750
    self.transitioning = false
end

function SceneManager:switchScene(timeElapsed)
    if self.transitioning then
        return
    end
    self.transitioning = true
    timeTotal += timeElapsed
    self:startTransition()
end

function SceneManager:loadNewScene()
    self:cleanupScene()
end

function SceneManager:startTransition()
    local transitionTimer = self:wipeTransition(0, 400)
    transitionTimer.timerEndedCallback = function()
        self:loadNewScene()
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

function SceneManager:getNextScene()
    if iterator == 0 then
        GameTitleScene()
        iterator += 1
    elseif iterator <= #sceneList then
        GameScene(sceneList[iterator])
        iterator +=  1
    else
        GameOverScene(timeTotal)
        iterator = 0
    end
end

function SceneManager:cleanupScene()
    gfx.sprite.removeAll()
    self:removeAllTimers()
    gfx.setDrawOffset(0,0)
    self:getNextScene()
end

function SceneManager:removeAllTimers()
    local allTimers = pd.timer.allTimers()
    for _, timer in ipairs(allTimers) do
        timer:remove()
    end
end
