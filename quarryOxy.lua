local startPos = vector.new(gps.locate(5))

local function digForward()
    turtle.dig()
    turtle.suck()
    turtle.forward()
end

local function getFacing()
    local facing
    local x, y, z = gps.locate(5)
    if not x then
        error("No GPS available", 0)
    end
    if turtle.forward() then
        local nx, ny, nz = gps.locate(5)
        if x - nx == 1 then
            -- East x+
            facing = 1
        elseif x - nx == -1 then
            -- West x-
            facing = 3
        elseif z - nz == 1 then
            -- South z+
            facing = 2
        else
            -- North z-
            facing = 0
        end
        turtle.turnLeft()
        turtle.turnLeft()
        turtle.forward()
        turtle.turnLeft()
        turtle.turnLeft()
    end
    return facing
end

if startPos.x ~= 0 then
    while true do
        -- Refuel
        while turtle.getFuelLevel() <= 300  do
            turtle.select(1)
            turtle.refuel(1)
        end
        -- Must go north
        while getFacing() ~= 2 do
            turtle.turnRight()
        end
        -- Change layer
        while not turtle.detectDown() do
            turtle.down()
        end
        turtle.digDown()
        turtle.down()
        local tX, tY, tZ = gps.locate(5)
        -- For each line
        for i=1,14 do
            -- For each column
            for j=1,13 do
                digForward()
            end
            turtle.turnRight()
            if turtle.detect() then
                digForward()
                turtle.turnRight()
            else
                turtle.turnLeft()
                turtle.turnLeft()
                digForward()
                turtle.turnLeft()
            end
        end
        -- Return home
        local homeDistance = vector.new(gps.locate(5)) - startPos
        if homeDistance.x >= 0 then
            -- Must go east
            while getFacing() ~= 1 do
                turtle.turnRight()
            end
        else 
            -- Must go west
            while getFacing() ~= 3 do
                turtle.turnRight()
            end
        end
        for i = 0, (homeDistance.x - 1), (homeDistance.x >= 0 and 1 or -1) do
            turtle.forward()
        end
        if homeDistance.z >= 0 then
            -- Must go south
            while getFacing() ~= 2 do
                turtle.turnRight()
            end
        else 
            -- Must go north
            while getFacing() ~= 0 do
                turtle.turnRight()
            end
        end
        for i = 0, (homeDistance.z - 1), (homeDistance.z >= 0 and 1 or -1) do
            turtle.forward()
        end
        for i = 1, (homeDistance.y + 2), -1 do
            turtle.up()
        end
        -- Must go north
        while getFacing() ~= 2 do
            turtle.turnRight()
        end
        -- Get coal and then empty himself
        turtle.turnLeft()
        turtle.select(1)
        turtle.suck(turtle.getItemSpace())
        turtle.turnLeft()
        for j = 2, 16 do
            turtle.select(j)
            turtle.drop()
        end
        turtle.turnLeft()
        turtle.turnLeft()
        if tY <= 6 then
            break;
        end
    end
else
    error("No GPS available", 0)
end