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
local offset

gfx.setFont(gfx.font.new("fonts/GlitchGoblin"))

class('GameScene').extends(gfx.sprite)

function GameScene:init(itemPath, rangeMin, rangeMax, goal)
    -- local backgroundImage = gfx.image.new("images/background")
    -- gfx.sprite.setBackgroundDrawingCallback(function()
    --     backgroundImage:draw(0, 0)
    -- end)

    self.itemPath = itemPath
    local score = 0
    local tickTimer = pd.timer.new(50, self.scoreUpdater)
    tickTimer.repeats = true

    timeTimer = pd.timer.new(1000, self.timeUpdater)
    timeTimer.repeats = true

    offset = math.random(-30,30)
    
    self.scoreGoal = goal

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
    targetArrow:moveTo(354,(120-(offset*2)))
    targetArrow:add()
    if itemPath == "images/screen" then
        item = Item(centerX, centerY, itemPath, self.scoreGoal)
    else
        item = Item(centerX+20, centerY+15, itemPath, self.scoreGoal)
    end
    targetRangeMin = rangeMin + offset
    targetRangeMax = rangeMax + offset

    self:add()
end

function GameScene:timeUpdater()
    timeElapsed += 1
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
        score += 4
    else
        if score >= 5 then
           --score -= 1
        else
            score = 0
        end
    end
    item:updateAnimationState(score)

    
    local shakeX, shakeY

    if item.width == 400 then
        if item.itemIter == 2 then
            shakeX = math.random(-4, 4)
            shakeY = math.random(-1, 1)
        elseif item.itemIter == 3 then
            shakeX = math.random(-7, 7)
            shakeY = math.random(-3, 3)
        else
            shakeX = 0
            shakeY = 0
        end
        progressSprite:moveTo(375 + shakeX, 120 + shakeY)
        infillSprite:moveTo(375 + shakeX, 120 + shakeY)
        surroundSprite:moveTo( 375+ shakeX, 120 + shakeY )
        targetArrow:moveTo(354 + shakeX,(120-(offset*2)) + shakeY)

    end

    
    
end

function GameScene:update()
    self:fillBar()
    if score >= self.scoreGoal then
        timeTimer:pause()
       if score <= (self.scoreGoal + 10) then
            if not(itemPath == "images/screen") then
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
            end
        end
       score =  self.scoreGoal + 1000
       if pd.buttonJustPressed(pd.kButtonA) then
           SCENE_MANAGER:switchScene(timeElapsed)
       end
    end
end
