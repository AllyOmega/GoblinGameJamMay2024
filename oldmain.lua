import "CoreLibs/graphics"
import "CoreLibs/timer"

local pd <const> = playdate
local gfx <const> = pd.graphics













function pd.update()
    gfx.clear()

    -- Update the animation state based on crank position
    

    -- Set color to black for drawing
    gfx.setColor(gfx.kColorBlack)

    gfx.sprite.update()
    pd.timer.updateTimers()

    pd.drawFPS(0, 0)
end

pd.start()
