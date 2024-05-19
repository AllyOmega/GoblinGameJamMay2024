import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/ui"

import "sceneManager"
import "gameScene"

SCENE_MANAGER = SceneManager()

GameScene()

local pd<const> = playdate
local gfx<const> = pd.graphics

function pd.update()
    pd.timer.updateTimers()
    gfx.sprite.update()
    pd.drawFPS(0, 0)
    if(pd.isCrankDocked()) then
        pd.ui.crankIndicator:draw()
    end
end
