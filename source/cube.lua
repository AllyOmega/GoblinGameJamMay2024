import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local pd<const> = playdate

local gfx<const> = pd.graphics


-- Define the cube vertices
local vertices = {
    { x = -1, y = -1, z = -1 },
    { x =  1, y = -1, z = -1 },
    { x =  1, y =  1, z = -1 },
    { x = -1, y =  1, z = -1 },
    { x = -1, y = -1, z =  1 },
    { x =  1, y = -1, z =  1 },
    { x =  1, y =  1, z =  1 },
    { x = -1, y =  1, z =  1 },
}

-- Define the cube faces
local faces = {
    {1, 2, 3, 4}, -- front
    {5, 6, 7, 8}, -- back
    {1, 2, 6, 5}, -- bottom
    {3, 4, 8, 7}, -- top
    {1, 4, 8, 5}, -- left
    {2, 3, 7, 6}, -- right
}

-- Define dithering patterns percentages for each face
local dithers = {
    0.15, -- front
    0.3, -- back
    0.45, -- bottom
    0.6, -- top
    0.75, -- left
    0.9  -- right
}

-- Function to project 3D points to 2D
local function project3D(x, y, z, offsetX, offsetY)
    local scale = 200 / (z + 4) -- Simple perspective projection
    local x2d = x * scale + 200 + offsetX
    local y2d = y * scale + 120 + offsetY
    return x2d, y2d
end

-- Function to rotate points
local function rotateX(x, y, z, angle)
    local cosTheta = math.cos(angle)
    local sinTheta = math.sin(angle)
    return x, y * cosTheta - z * sinTheta, y * sinTheta + z * cosTheta
end

local function rotateY(x, y, z, angle)
    local cosTheta = math.cos(angle)
    local sinTheta = math.sin(angle)
    return x * cosTheta + z * sinTheta, y, -x * sinTheta + z * cosTheta
end

local function rotateZ(x, y, z, angle)
    local cosTheta = math.cos(angle)
    local sinTheta = math.sin(angle)
    return x * cosTheta - y * sinTheta, x * sinTheta + y * cosTheta, z
end

local angleX, angleY, angleZ = 0, 0, 0
local currentAxis = "x" -- Default rotation axis

-- Function to draw a filled polygon with dithering
local function drawPolygonWithDither(points, ditherLevel)
    gfx.setDitherPattern(ditherLevel)
    local n = #points
    for i = 1, n - 2 do
        gfx.fillPolygon(
            points[1].x, points[1].y,
            points[i + 1].x, points[i + 1].y,
            points[i + 2].x, points[i + 2].y
        )
    end
    gfx.setDitherPattern(1.0) -- Reset to solid for other drawing
end

-- Function to draw a single cube at given offsets
local function drawCube(offsetX, offsetY)
    local projected = {}

    for i, vertex in ipairs(vertices) do
        local x, y, z = vertex.x, vertex.y, vertex.z
        x, y, z = rotateX(x, y, z, angleX)
        x, y, z = rotateY(x, y, z, angleY)
        x, y, z = rotateZ(x, y, z, angleZ)
        local x2d, y2d = project3D(x, y, z, offsetX, offsetY)
        projected[i] = { x = x2d, y = y2d }
    end

    for i, face in ipairs(faces) do
        local points = {}
        for _, index in ipairs(face) do
            table.insert(points, projected[index])
        end
        drawPolygonWithDither(points, dithers[i])
    end
end

-- Variables for framerate counter
local frameCount = 0
local fps = 0
local lastTime = pd.getCurrentTimeMilliseconds()

-- Update function to rotate the cubes and calculate FPS
function pd.update()
    -- Update the current axis of rotation based on D-pad input
    if pd.buttonIsPressed(pd.kButtonUp) then
        currentAxis = "x"
    elseif pd.buttonIsPressed(pd.kButtonRight) then
        currentAxis = "y"
    elseif pd.buttonIsPressed(pd.kButtonDown) then
        currentAxis = "z"
    end

    -- Update the rotation angle based on the crank
    local crankAngle = pd.getCrankPosition() * (math.pi / 180)
    if currentAxis == "x" then
        angleX = crankAngle
    elseif currentAxis == "y" then
        angleY = crankAngle
    elseif currentAxis == "z" then
        angleZ = crankAngle
    end

    gfx.clear()

   drawCube(0,0)

    -- Calculate and display FPS
    frameCount = frameCount + 1
    local currentTime = pd.getCurrentTimeMilliseconds()
    if currentTime - lastTime >= 1000 then
        fps = frameCount
        frameCount = 0
        lastTime = currentTime
    end

    gfx.drawText("FPS: " .. tostring(fps), 5, 5)
    gfx.drawText("Current axis: " .. currentAxis, 5, 25)

    pd.timer.updateTimers()
end

pd.start()
