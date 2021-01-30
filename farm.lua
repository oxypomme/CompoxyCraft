local LENGTH = 9
local WIDTH = 10
local SEED = "minecraft:potato"

local function refuel()
    while turtle.getFuelLevel() <= 3*(LENGTH*WIDTH) do
        for i = 1, 16 do
            local item = turtle.getItemDetail(i)
            if not item then
                turtle.select(i)
                break
            end
        end
        turtle.suck(1)
        turtle.refuel(1)
    end
    turtle.select(1)
end

local function drop()
    for i = 2, 16 do
        turtle.select(i)
        turtle.drop()
    end
end

local function turnBack()
    turtle.turnLeft()
    turtle.turnLeft()
end

local function plant()
    for i = 1, 16 do
        local item = turtle.getItemDetail(i)
        if item and item.name == SEED then
            turtle.select(i)
            turtle.placeDown()
            break
        end
    end
end

local function forward()
    local isBlock, block = turtle.inspectDown()
    if isBlock then
        if block.state.age == 7 then
            turtle.digDown()
            plant()
        end
    else
        plant()
    end
    turtle.suckDown()
    while not turtle.forward() do
        os.sleep(1)
    end
end

while true do
    -- Refuel and empty it's inventory
    print("Restocking")
    turtle.turnLeft()
    refuel()
    turtle.turnLeft()
    drop()
    turnBack()
    for k = 1, 2 do
        print("Going to plant things")
        for i = 1, LENGTH do
            for j = 1, WIDTH do
                forward()
            end
            if i < LENGTH then
                if i % 2 == 1 then
                    turtle.turnRight()
                    forward()
                    turtle.turnRight()
                else
                    turtle.turnLeft()
                    forward()
                    turtle.turnLeft()
                end
                print("Changing line")
            end
        end
        turnBack()
    end
end