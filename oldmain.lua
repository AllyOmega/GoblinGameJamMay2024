import "CoreLibs/graphics"
import "CoreLibs/timer"

local pd <const> = playdate
local gfx <const> = pd.graphics

local screenWidth, screenHeight = pd.display.getSize()
local centerX, centerY = screenWidth / 2, screenHeight / 2

local ballImageTable = gfx.imagetable.new('images/ball')

local ballImages = {}

for i = 1, #ballImageTable do 
    ballImages[i] = ballImageTable[i]
end

playdate.sound.micinput.startListening()

local ballSprite = gfx.sprite.new()
ballSprite:setImage(ballImages[1])
ballSprite:moveTo(centerX, centerY)
ballSprite:add()  -- Add the sprite to the sprite system
ballSprite:setScale(2)

local shakeTimer

local ballIter = 0

local function updateAnimationState()
    local micLevel = playdate.sound.micinput.getLevel()

    print(micLevel)
    -- Map the microphone input level to ballIter (1 to 4)

    if ballIter < 4 then
        if micLevel < 0.01 then
            ballIter = 1
        elseif micLevel < 0.03 then
            ballIter = 2
        elseif micLevel < 0.075 then
            ballIter = 3
        else
            ballIter = 4
        end
    end
    ballSprite:setImage(ballImages[ballIter])

    -- Adjust the shaking speed based on ballIter
    if ballIter == 2 then
        shakeTimer.duration = 100  -- Shake every 100 ms
    elseif ballIter == 3 then
        shakeTimer.duration = 50  -- Shake every 50 ms
    else
        shakeTimer.duration = 5000  -- No shaking, set a large interval
    end
end

local function shakeBall()
    -- Apply shaking effect
    if ballIter == 2 then
        local shakeX = math.random(-5, 5)
        local shakeY = math.random(-2, 2)
        ballSprite:moveTo(centerX + shakeX, centerY + shakeY)
    elseif ballIter == 3 then
        local shakeX = math.random(-10, 10)
        local shakeY = math.random(-4, 4)
        ballSprite:moveTo(centerX + shakeX, centerY + shakeY)
    else
        ballSprite:moveTo(centerX, centerY)
    end
end

-- Create the shake timer
shakeTimer = pd.timer.new(50, shakeBall)
shakeTimer.repeats = true

function pd.update()
    gfx.clear()

    -- Update the animation state based on crank position
    updateAnimationState()

    -- Set color to black for drawing
    gfx.setColor(gfx.kColorBlack)

    gfx.sprite.update()
    pd.timer.updateTimers()

    pd.drawFPS(0, 0)
end

pd.start()
