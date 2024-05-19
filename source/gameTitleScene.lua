import "gameScene"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local fontPaths = {[gfx.font.kVariantNormal] = "fonts/GlitchGoblin"}

gfx.setFont(gfx.font.new("fonts/GlitchGoblin"))

class('GameTitleScene').extends(gfx.sprite)

function GameTitleScene:init()

    local text = "Let's"
    local gameTitleImage = gfx.image.new(gfx.getTextSize(text))
    gfx.pushContext(gameTitleImage)
        gfx.drawText(text, 0, 0)
    gfx.popContext()
    local gameTitleSprite = gfx.sprite.new(gameTitleImage)
    gameTitleSprite:moveTo(200, 50)
    gameTitleSprite:setZIndex(10001)
    gameTitleSprite:add()

    local text1 = "GET"
    local gameTitleImage1 = gfx.image.new(gfx.getTextSize(text1))
    gfx.pushContext(gameTitleImage1)
        gfx.drawText(text1, 0, 0)
    gfx.popContext()
    local gameTitleSprite1 = gfx.sprite.new(gameTitleImage1)
    gameTitleSprite1:moveTo(200, 100)
    gameTitleSprite1:setZIndex(10001)
    gameTitleSprite1:add()

    local text2 = "FRACKin !"
    local gameTitleImage2 = gfx.image.new(gfx.getTextSize(text2))
    gfx.pushContext(gameTitleImage2)
        gfx.drawText(text2, 0, 0)
    gfx.popContext()
    local gameTitleSprite2 = gfx.sprite.new(gameTitleImage2)
    gameTitleSprite2:moveTo(200, 150)
    gameTitleSprite2:setZIndex(10002)
    gameTitleSprite2:add()


    --local text2 = "PRESS A for CRANK or B for Mic"
    local text2 = "PRESS A"
    local gameTitleImage2 = gfx.image.new(gfx.getTextSize(text2))
    gfx.pushContext(gameTitleImage2)
        gfx.drawText(text2, 0, 0)
    gfx.popContext()

    local gameTitleSprite2 = gfx.sprite.new(gameTitleImage2)
    gameTitleSprite2:setScale(.5)
    gameTitleSprite2:moveTo(200, 200)
    gameTitleSprite2:add()

    self:add()

end

function GameTitleScene:update()
    if pd.buttonJustPressed(pd.kButtonA) then
        SCENE_MANAGER:switchScene(0)
    end
end
