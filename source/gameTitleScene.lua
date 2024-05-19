import "gameSceneCup"

local pd <const> = playdate
local gfx <const> = playdate.graphics


class('GameTitleScene').extends(gfx.sprite)

function GameTitleScene:init()

    local text1 = "START!"
    local gameTitleImage1 = gfx.image.new(gfx.getTextSize(text1))
    gfx.pushContext(gameTitleImage1)
        gfx.drawText(text1, 0, 0)
    gfx.popContext()

    local gameTitleSprite1 = gfx.sprite.new(gameTitleImage1)

    gameTitleSprite1:moveTo(200, 120)
    gameTitleSprite1:add()

    local text2 = "PRESS A!"
    local gameTitleImage2 = gfx.image.new(gfx.getTextSize(text2))
    gfx.pushContext(gameTitleImage2)
        gfx.drawText(text2, 0, 0)
    gfx.popContext()

    local gameTitleSprite2 = gfx.sprite.new(gameTitleImage2)

    gameTitleSprite2:moveTo(200, 180)
    gameTitleSprite2:add()

    self:add()

end

function GameTitleScene:update()
    if pd.buttonJustPressed(pd.kButtonA) then
        SCENE_MANAGER:switchScene(GameSceneCup, 0)
    end
end
