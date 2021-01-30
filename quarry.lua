local width = 14 -- only even
local depth = 14

local function tryDigForward()
    if turtle.detect() then
        turtle.dig()
        turtle.suck()
    end
    while not turtle.forward() do
        os.sleep(1)
    end
end

local function tryDigDown()
    if turtle.detectDown() then
        turtle.digDown()
        turtle.suckDown()
    end
    turtle.down()
end

local function tryDigUp()
    if turtle.detectUp() then
        turtle.digUp()
        turtle.suckUp()
    end
    turtle.up()
end

local function quarryLine()
    for i=1, width, 1 do
        for j=1, depth - 1, 1 do
            tryDigForward()
        end

        if i ~= width then
            if i % 2 == 1 then
                turtle.turnRight()
                tryDigForward()
                turtle.turnRight()
            else
                turtle.turnLeft()
                tryDigForward()
                turtle.turnLeft()
            end
        end
    end
    if width % 2 == 1 then
        turtle.turnRight()
        turtle.turnRight()
        for j=1, depth - 1, 1 do
            tryDigForward()
        end
    end
    turtle.turnRight()
    for j=1, width - 1, 1 do
        tryDigForward()
    end
    turtle.turnRight()
end


local function refuelFull()
    print("Initial fuel level : " .. turtle.getFuelLevel())
    turtle.turnLeft()
    -- TODO take enought to go up and down, and do the line
    while turtle.getFuelLevel() <= 300  do
        turtle.suck(1)
        local worked, errorString = turtle.refuel(1)
        if not worked then
            error(errorString)
        end
    end
    turtle.turnRight()
end

local function dropAllItems()
    turtle.turnLeft()
    turtle.turnLeft()
    for i = 1, 16, 1 do -- 16 slots
        turtle.select(i)
        turtle.drop()
    end
    turtle.turnRight()
    turtle.turnRight()
end


local startPos = vector.new(gps.locate(5)) -- x, y, z
if startPos.y then
    local height = startPos.y - 6
    print("Height to mine : " .. height)
    for i=1, height, 1 do
        refuelFull()
        for j=1, i, 1 do
            tryDigDown()
        end
        quarryLine()
        for j=1, i, 1 do
            tryDigUp()
        end
        dropAllItems()
    end
else
    error("GPS not found !")
end
