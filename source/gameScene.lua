import "gameOverScene"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local progressPercent = 10
local targetRangeMax = 55
local targetRangeMin = 45

local item
local screenWidth, screenHeight = pd.display.getSize()
local centerX, centerY = screenWidth / 2, screenHeight / 2
local fontPaths = {[gfx.font.kVariantNormal] = "fonts/GlitchGoblin"}

local timeTimer
local timeElapsed = 0

gfx.setFont(gfx.font.new("fonts/GlitchGoblin"))

class('GameScene').extends(gfx.sprite)

function GameScene:init(itemPath)
    -- local backgroundImage = gfx.image.new("images/background")
    -- gfx.sprite.setBackgroundDrawingCallback(function()
    --     backgroundImage:draw(0, 0)
    -- end)
    local score = 0
    local tickTimer = pd.timer.new(50, self.scoreUpdater)
    tickTimer.repeats = true

    timeTimer = pd.timer.new(1000, self.timeUpdater)
    timeTimer.repeats = true
    


    local progressImage = gfx.imagetable.new("images/progress-dither")
    assert( progressImage )

    infillSprite = gfx.sprite.new( progressImage[1] )
    infillSprite:moveTo( 375, 120 )
    infillSprite:add()

    progressSprite = gfx.sprite.new( progressImage[3] )
    progressSprite:moveTo( 375, 120  )
    progressSprite:add()

    surroundSprite = gfx.sprite.new( progressImage[2] )
    surroundSprite:moveTo( 375, 120  )
    surroundSprite:add()

    local arrowImg = gfx.image.new('images/arrow')
    targetArrow = gfx.sprite.new(arrowImg)
    assert( targetArrow )

    targetArrow:moveTo(354,120)
    targetArrow:add()

    item = Item(centerX+20, centerY+15, itemPath)

    self:add()
end

function GameScene:timeUpdater()
    timeElapsed += 1

   --print("timeTimer: " .. tostring(timeElapsed))
end

function GameScene:updateProgress()
	progressSprite:setClipRect(progressSprite.x-progressSprite.width/2, progressSprite.y-progressPercent*2+progressSprite.height/2, progressSprite.width, progressPercent*2 )
end

function GameScene:fillBar()
    progressPercent += (pd.getCrankChange()//9)
	if progressPercent > 120 then
        progressPercent = 120
    end
    if progressPercent <= 0 then
        progressPercent = 0
    end
	self:updateProgress()
    --progressPercent -= (math.random(5,12)//2)
end

function GameScene:scoreUpdater()
    if progressPercent > targetRangeMin and progressPercent < targetRangeMax then
        local median = ((targetRangeMin+targetRangeMax)//2)
         score += (median - targetRangeMin) - math.abs(median-progressPercent) --copy idea for dec score?
    else
        if score >= 5 then
            score -= 1
        else
            score = 0
        end
    end
    item:updateAnimationState(score)
end

function GameScene:update()
    self:fillBar()
    if score >= 100 then
        timeTimer:pause()
        --print("time before: " .. tostring(timeElapsed))
       if score <= 110 then
            local text1 = "GET Fracked"
            local gameTitleImage1 = gfx.image.new(gfx.getTextSize(text1))
            gfx.pushContext(gameTitleImage1)
                gfx.drawText(text1, 0, 0)
            gfx.popContext()
            local gameTitleSprite1 = gfx.sprite.new(gameTitleImage1)
            gameTitleSprite1:moveTo(165, 30)
            gameTitleSprite1:setZIndex(10001)
            gameTitleSprite1:add()

            local text3 = "Press A"
            local gameTitleImage3 = gfx.image.new(gfx.getTextSize(text3))
            gfx.pushContext(gameTitleImage3)
                gfx.drawText(text3, 0, 0)
            gfx.popContext()
            local gameTitleSprite3 = gfx.sprite.new(gameTitleImage3)
            gameTitleSprite3:setScale(.5)
            gameTitleSprite3:moveTo(55, 210)
            gameTitleSprite3:setZIndex(10002)
            gameTitleSprite3:add()
            --print("time after: " .. tostring(timeElapsed))
       end
       score =  200
       if pd.buttonJustPressed(pd.kButtonA) then
           SCENE_MANAGER:switchScene(timeElapsed)
       end
    end
end
