import "gameSceneBall"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local progressPercent = 10
local scoreCup = 0
local targetRangeMax = 55
local targetRangeMin = 45

local itemCup
local screenWidth, screenHeight = pd.display.getSize()
local centerX, centerY = screenWidth / 2, screenHeight / 2


class('GameSceneCup').extends(gfx.sprite)

function GameSceneCup:init(scoreCup)
    -- local backgroundImage = gfx.image.new("images/background")
    -- gfx.sprite.setBackgroundDrawingCallback(function()
    --     backgroundImage:draw(0, 0)
    -- end)
    scoreCup = 0
    local tickTimer = pd.timer.new(50, self.scoreUpdater)
    tickTimer.repeats = true

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

    itemCup = Item(centerX, centerY, 'images/cup')

    self:add()
end

function GameSceneCup:updateProgress()
	progressSprite:setClipRect(progressSprite.x-progressSprite.width/2, progressSprite.y-progressPercent*2+progressSprite.height/2, progressSprite.width, progressPercent*2 )
end

function GameSceneCup:fillBar()
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

function GameSceneCup:scoreUpdater()
    if progressPercent > targetRangeMin and progressPercent < targetRangeMax then
        local median = ((targetRangeMin+targetRangeMax)//2)
         scoreCup += (median - targetRangeMin) - math.abs(median-progressPercent) --copy idea for dec score?
    else
        if scoreCup >= 5 then
            scoreCup -= 1
        else
            scoreCup = 0
        end
    end
    itemCup:updateAnimationState(scoreCup)
end

function GameSceneCup:update()
    self:fillBar()
    if scoreCup >= 100 then
        SCENE_MANAGER:switchScene(GameSceneBall, 0)
    end
end
