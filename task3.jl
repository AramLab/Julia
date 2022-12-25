include("functionsForRobot.jl")
using HorizonSideRobots
r=Robot(animate=true)

"""function mark_all!(robot::Robot)
    numsteps_Sud = numsteps_along!(robot, Sud)
    numsteps_West = numsteps_along!(robot, West)
    while !ismarker(robot)
        for side in (Ost, West)
            putmarkers!(robot, side)
        end
    end
    moves!(robot, Nord, numsteps_Sud)
    moves!(robot, Ost, numsteps_West)
end"""

function mark_fild!(r::Robot)
    steps_to_origin = get_left_down_angle!(r)
    putmarker!(r)
    while !isborder(r, Ost)
        putmarkers_until_border!(r,Nord)
        move!(r, Ost)
        putmarker!(r)
        putmarkers_until_border!(r, Sud)
    end
    get_left_down_angle!(r)
    get_to_origin!(r, steps_to_origin)
end