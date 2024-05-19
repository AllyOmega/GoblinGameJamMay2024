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

function GameScene:init(itemPath, rangeMin, rangeMax)
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

    item = Item(centerX, centerY, itemPath)

    targetRangeMin = rangeMin
    targetRangeMax = rangeMax

    self:add()
end

function GameScene:timeUpdater()
    timeElapsed += 1

    print("timeTimer: " .. tostring(timeElapsed))
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
    progressPercent -= (math.random(5,12)//2)
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
        print("time before: " .. tostring(timeElapsed))
        score =  200
        local text1 = "GET"
        local gameTitleImage1 = gfx.image.new(gfx.getTextSize(text1))
        gfx.pushContext(gameTitleImage1)
            gfx.drawText(text1, 0, 0)
        gfx.popContext()
        local gameTitleSprite1 = gfx.sprite.new(gameTitleImage1)
        gameTitleSprite1:moveTo(200, 30)
        gameTitleSprite1:setZIndex(10001)
        gameTitleSprite1:add()
    
        local text2 = "FRACKED"
        local gameTitleImage2 = gfx.image.new(gfx.getTextSize(text2))
        gfx.pushContext(gameTitleImage2)
            gfx.drawText(text2, 0, 0)
        gfx.popContext()
        local gameTitleSprite2 = gfx.sprite.new(gameTitleImage2)
        gameTitleSprite2:moveTo(200, 80)
        gameTitleSprite2:setZIndex(10002)
        gameTitleSprite2:add()

        local text3 = "Press A"
        local gameTitleImage3 = gfx.image.new(gfx.getTextSize(text3))
        gfx.pushContext(gameTitleImage3)
            gfx.drawText(text3, 0, 0)
        gfx.popContext()
        local gameTitleSprite3 = gfx.sprite.new(gameTitleImage3)
        gameTitleSprite3:moveTo(200, 200)
        gameTitleSprite3:setZIndex(10002)
        gameTitleSprite3:add()
        print("time after: " .. tostring(timeElapsed))

        if pd.buttonJustPressed(pd.kButtonA) then
            SCENE_MANAGER:switchScene(timeElapsed)
        end
    end
end
