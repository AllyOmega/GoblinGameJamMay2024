import "gameTitleScene"
import "gameScene"

local pd <const> = playdate
local gfx <const> = playdate.graphics


local fontPaths = {[gfx.font.kVariantNormal] = "fonts/GlitchGoblin"}

gfx.setFont(gfx.font.new("fonts/GlitchGoblin"))

class('GameOverScene').extends(gfx.sprite)

function GameOverScene:init(timeElapsed)

    local text = "GAME OVER"
     
    local gameOverImage = gfx.image.new(gfx.getTextSize(text))
    local finalScoreImage = gfx.image.new(gfx.getTextSize(tostring(timeElapsed).."  seconds!"))
    gfx.pushContext(gameOverImage)
        gfx.drawText(text, 0, 0)
    gfx.popContext()
    gfx.pushContext(finalScoreImage)
        gfx.drawText(timeElapsed .. "  seconds!", 0, 0)
    gfx.popContext()

    local gameOverSprite = gfx.sprite.new(gameOverImage)
    local finalScoreSprite = gfx.sprite.new(finalScoreImage)
    
    gameOverSprite:moveTo(200, 80)
    gameOverSprite:add()   

    finalScoreSprite:moveTo(200, 180)
    finalScoreSprite:add()
    
    local text3 = "Final Time: "
    local gameTitleImage3 = gfx.image.new(gfx.getTextSize(text3))
    gfx.pushContext(gameTitleImage3)
        gfx.drawText(text3, 0, 0)
    gfx.popContext()
    local gameTitleSprite3 = gfx.sprite.new(gameTitleImage3)
    gameTitleSprite3:setScale(.5)
    gameTitleSprite3:moveTo(200, 140)
    gameTitleSprite3:add()


    self:add()

end

function GameOverScene:update()
    if pd.buttonJustPressed(pd.kButtonA) then

        SCENE_MANAGER:switchScene(GameTitleScene)

    end
end
