import "gameOverScene"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local progressPercent = 10
local targetRangeMax = 55
local targetRangeMin = 45

local itemBall
local screenWidth, screenHeight = pd.display.getSize()
local centerX, centerY = screenWidth / 2, screenHeight / 2


class('GameSceneBall').extends(gfx.sprite)

function GameSceneBall:init()
    -- local backgroundImage = gfx.image.new("images/background")
    -- gfx.sprite.setBackgroundDrawingCallback(function()
    --     backgroundImage:draw(0, 0)
    -- end)
    local scoreBall = 0
    local tickTimer2 = pd.timer.new(50, self.scoreUpdaterBall)
    tickTimer2.repeats = true

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

    itemBall = Item(centerX, centerY, 'images/ball')

    self:add()
end

function GameSceneBall:updateProgress()
	progressSprite:setClipRect(progressSprite.x-progressSprite.width/2, progressSprite.y-progressPercent*2+progressSprite.height/2, progressSprite.width, progressPercent*2 )
end

function GameSceneBall:fillBar()
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

function GameSceneBall:scoreUpdaterBall()
    --print("In ScoreUpdater" .. tostring(progressPercent))
    if progressPercent > targetRangeMin and progressPercent < targetRangeMax then
        local median = ((targetRangeMin+targetRangeMax)//2)
         scoreBall += (median - targetRangeMin) - math.abs(median-progressPercent) --copy idea for dec score?
    else
        if scoreBall >= 5 then
            scoreBall -= 1
        else
            scoreBall = 0
        end
    end
    itemBall:updateAnimationState(scoreBall)
end

function GameSceneBall:update()
    self:fillBar()
    if scoreBall >= 100 then
        scoreBall = 0
        SCENE_MANAGER:switchScene(GameOverScene)
    end
end
