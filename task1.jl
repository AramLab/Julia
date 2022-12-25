include("functionsForRobot.jl")
using HorizonSideRobots
r=Robot(animate=true)

function mark_cross!(r::Robot)
    for side in (Nord, Sud, West, Ost)
        n_steps = putmarkers_until_border!(r, side)
        moves!(r, inverse_side(side), n_steps)
    end
    putmarker!(r)
end