import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/ui"

import "sceneManager"
import "gameTitleScene"
import "item"

SCENE_MANAGER = SceneManager()

GameTitleScene()

local pd<const> = playdate
local gfx<const> = pd.graphics

pd.setCollectsGarbage(false)

function pd.update()
    pd.timer.updateTimers()
    gfx.sprite.update()
    pd.drawFPS(0, 0)
    if(pd.isCrankDocked()) then
        pd.ui.crankIndicator:draw()
    end
end
