import "gameTitleScene"
import "gameScene"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local fontPaths = {[gfx.font.kVariantNormal] = "fonts/GlitchGoblin"}

gfx.setFont(gfx.font.new("fonts/GlitchGoblin"))

class('GameOverScene').extends(gfx.sprite)

function GameOverScene:init()

    local text = "GAME OVER"
    local finalScore = 200
    local gameOverImage = gfx.image.new(gfx.getTextSize(text))
    local finalScoreImage = gfx.image.new(gfx.getTextSize(finalScore))
    gfx.pushContext(gameOverImage)
        gfx.drawText(text, 0, 0)
    gfx.popContext()
    gfx.pushContext(finalScoreImage)
        gfx.drawText(finalScore, 0, 0)
    gfx.popContext()

    local gameOverSprite = gfx.sprite.new(gameOverImage)
    local finalScoreSprite = gfx.sprite.new(finalScoreImage)
    
    gameOverSprite:moveTo(200, 120)
    gameOverSprite:add()   

    finalScoreSprite:moveTo(200, 180)
    finalScoreSprite:add()

    self:add()

end

function GameOverScene:update()
    if pd.buttonJustPressed(pd.kButtonA) then

        SCENE_MANAGER:switchScene(GameTitleScene)

    end
end
