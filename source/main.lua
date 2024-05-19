import "CoreLibs/graphics"
import "CoreLibs/timer"
import "CoreLibs/ui"
import "CoreLibs/object"
import "item"

local pd<const> = playdate
local gfx<const> = pd.graphics
local fillHeight = -20
local fillIncr = -1
local progressPercent = 10
local score = 0
local targetRangeMax = 55
local targetRangeMin = 45
local tickCount = 0

local screenWidth, screenHeight = pd.display.getSize()
local centerX, centerY = screenWidth / 2, screenHeight / 2

playdate.sound.micinput.startListening()

local micLevel = playdate.sound.micinput.getLevel()

local function setupGame()
    local item = Item(centerX, centerY)

    local font<const> = gfx.getFont()
    local greeting<const> = "Hello, CuberPunk!"
    local w<const> = font:getTextWidth(greeting)
    local h<const> = font:getHeight()
    local x<const> = (400 - w) / 2
    local y<const> = (240 - h) / 2
    gfx.drawText(greeting, x, y)

    local progressImage = gfx.imagetable.new("images/progress-dither")
    assert(progressImage)

    local infillSprite = gfx.sprite.new(progressImage[1])
    infillSprite:moveTo(375, 120)
    infillSprite:add()

    local progressSprite = gfx.sprite.new(progressImage[3])
    progressSprite:moveTo(375, 120)
    progressSprite:add()

    local surroundSprite = gfx.sprite.new(progressImage[2])
    surroundSprite:moveTo(375, 120)
    surroundSprite:add()

    local arrowImg = gfx.image.new('images/arrow')
    local targetArrow = gfx.sprite.new(arrowImg)
    assert(targetArrow)
    targetArrow:moveTo(354, 120)
    targetArrow:add()

    local function updateProgress(sprite)
        sprite:setClipRect(sprite.x - sprite.width / 2, sprite.y - progressPercent * 2 + sprite.height / 2, sprite.width, progressPercent * 2)
    end

    local function fillBar()
        progressPercent += pd.getCrankChange() // 9
        if progressPercent > 120 then
            progressPercent = 120
        end
        if progressPercent <= 0 then
            progressPercent = 0
        end
        updateProgress(progressSprite)
        progressPercent -= (math.random(5, 12) // 2)
    end

    local function scoreUpdater()
        if progressPercent > targetRangeMin and progressPercent < targetRangeMax then
            local median = ((targetRangeMin + targetRangeMax) // 2)
            score += (median - targetRangeMin) - math.abs(median - progressPercent)
        else
            if score >= 5 then
                score -= 1
            else
                score = 0
            end
        end

        item:updateAnimationState(score)
    end

    local tickTimer = pd.timer.new(50, scoreUpdater)
    tickTimer.repeats = true

    function pd.update()
        fillBar()
        gfx.sprite.update()
        playdate.timer.updateTimers()
        gfx.drawText(tostring(math.floor(score)), 0, 220)
        pd.drawFPS(0, 0)

        if (pd.isCrankDocked()) then
            pd.ui.crankIndicator:draw()
        end
    end
end

setupGame()
pd.start()
