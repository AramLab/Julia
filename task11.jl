include("functionsForRobot.jl")
using HorizonSideRobots
r=Robot(animate=true)

function num_borders(r::Robot)
    side = Ost
    num=0
    while isborder(r,Nord)==false
        while isborder(r,side)==false
            if pass_the_borders(r,side) == true
                num += 1
                walk_by(r,side)
            end
        end
        move!(r,Nord)
        side = inverse(side)
    end
    return num
end
function pass_the_borders(r::Robot,side::HorizonSide) 
    while isborder(r,Nord)==false 
        if isborder(r,side) == true
            return false
        end
        move!(r,side) 
    end
    return true
end
walk_by(r::Robot,side::HorizonSide) = while isborder(r,Nord)==true move!(r,side) end
inverse(side::HorizonSide)=HorizonSide(mod(Int(side)+2,4))