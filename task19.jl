include("functionsForRobot.jl")
using HorizonSideRobots
r=Robot(animate=true)

function putmarker_at_border_and_back!(robot::Robot, side::HorizonSide, n_steps::Int = 0)
    if !isborder(r, side)
        move!(r, side)
        n_steps += 1
        putmarker_at_border_and_back!(r, side, n_steps)
    else
        putmarker!(r)
        along!(robot, inverse_side(side), n_steps)
    end
end