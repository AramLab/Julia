include("functionsForRobot.jl")
using HorizonSideRobots
r=Robot(animate=true)

function find_marker!(r::Robot)
    tmp = (side::HorizonSide) -> ismarker(r)
    spiral!( tmp, r)
end