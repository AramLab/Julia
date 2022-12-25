include("functionsForRobot.jl")
using HorizonSideRobots
r=Robot(animate=true)


function tolim!(robot, side)
    if !isborder(robot, side)
        move!(robot,side)
        tolim!(robot, side)
    end
end