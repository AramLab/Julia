include("functionsForRobot.jl")
using HorizonSideRobots
r=Robot(animate=true)

function d_krest!(robot::Robot)
    for side in ((Nord, Ost), (Ost, Sud), (Sud, West), (West, Nord))
        move_putmarker!(robot, side)
        move_by_markers(robot, inverse(side))
    end
    putmarker!(robot)
end