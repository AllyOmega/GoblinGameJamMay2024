import "gameOverScene"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local progressPercent = 10
local score = 0
local targetRangeMax = 55
local targetRangeMin = 45

class('GameScene').extends(gfx.sprite)

function GameScene:init()
    -- local backgroundImage = gfx.image.new("images/background")
    -- gfx.sprite.setBackgroundDrawingCallback(function()
    --     backgroundImage:draw(0, 0)
    -- end)
    local tickTimer = pd.timer.new(50, scoreUpdater)
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

    self:add()
end

function updateProgress()
	progressSprite:setClipRect(progressSprite.x-progressSprite.width/2, progressSprite.y-progressPercent*2+progressSprite.height/2, progressSprite.width, progressPercent*2 )
end

function fillBar()

    progressPercent += (pd.getCrankChange()//9)
	if progressPercent > 120 then
        progressPercent = 120
    end
    if progressPercent <= 0 then
        progressPercent = 0
    end
	updateProgress()
    progressPercent -= (math.random(5,12)//2)

end

function scoreUpdater()

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

end

function GameScene:update()
    fillBar()
    --pd.timer.updateTimers()
    local tempScore = tostring(math.floor(score))
    print(tempScore)
    if pd.buttonJustPressed(pd.kButtonA) then
        SCENE_MANAGER:switchScene(GameOverScene, tempScore)
    end
end
