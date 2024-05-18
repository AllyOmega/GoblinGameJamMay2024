import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/ui"

local pd<const> = playdate
local gfx<const> = pd.graphics
local fillHeight = -20
local fillIncr = -1
local progressPercent = 10
local score = 0
local targetRangeMax = 55
local targetRangeMin = 45
local tickCount = 0


function setupGame()

    -- local backgroundImage = gfx.image.new( "images/background" )
    -- assert( backgroundImage )

    -- gfx.sprite.setBackgroundDrawingCallback(
    --     function( x, y, width, height )
    --         gfx.setClipRect( x, y, width, height )
    --         backgroundImage:draw( 0, 0 )
    --         gfx.clearClipRect()
    --     end
    -- )

    local font<const> = gfx.getFont()
    local greeting<const> = "Hello, CuberPunk!"
    local w<const> = font:getTextWidth(greeting)
    local h<const> = font:getHeight()
    local x<const> = (400 - w) / 2
    local y<const> = (240 - h) / 2
    gfx.drawText(greeting, x, y)

    local progressImage = gfx.imagetable.new("images/progress-dither")
    assert( progressImage )

    infillSprite = gfx.sprite.new( progressImage[1] )
    infillSprite:moveTo( 375, 120 )
    infillSprite:add()

    progressSprite = gfx.sprite.new( progressImage[3] )
    progressSprite:moveTo( 375, 120  )
	updateProgress()
    progressSprite:add()

    surroundSprite = gfx.sprite.new( progressImage[2] )
    surroundSprite:moveTo( 375, 120  )
    surroundSprite:add()

    local arrowImg = gfx.image.new('images/arrow')
    targetArrow = gfx.sprite.new(arrowImg)
    assert( targetArrow )
    targetArrow:moveTo(354,120)
    targetArrow:add()

end

function updateProgress()
	progressSprite:setClipRect(progressSprite.x-progressSprite.width/2, progressSprite.y-progressPercent*2+progressSprite.height/2, progressSprite.width, progressPercent*2 )
end

function fillBar()

    progressPercent += (pd.getCrankChange()//8)
	if progressPercent > 120 or progressPercent <= 0 then progressPercent = 0 end
	updateProgress()
    progressPercent -= (math.random(5,10)//2)

end
 function gameLoop()

    if progressPercent > (targetRangeMin+2) and progressPercent < (targetRangeMax-2)  then
        tickCount += 1
        if tickCount >= 4 then
            score += 2
        end
    elseif progressPercent > targetRangeMin and progressPercent < targetRangeMax then
        tickCount += 1
        if tickCount >= 3 then
            score += 1
        end
    else
        tickCount = 0
        if score >= 5 then
            score -= 1
        else
            score = 0
        end
    end

 end



setupGame()

function pd.update()

    fillBar()
    gameLoop()
    gfx.sprite.update()
    playdate.timer.updateTimers()
    gfx.drawText(tostring(score), 0, 220)
    pd.drawFPS(0, 0)

    if(pd.isCrankDocked()) then
        pd.ui.crankIndicator:draw()
    end
end
