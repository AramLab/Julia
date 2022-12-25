include("functionsForRobot.jl")
using HorizonSideRobots
r=Robot(animate=true)

function mark_perimetr!(r::Robot)
    steps_to_left_down_angle = [0, 0] # (шаги_вниз, шаги_влево)
    steps_to_left_down_angle[1] = move_until_border!(r, Sud)
    steps_to_left_down_angle[2] = move_until_border!(r, West)
    for side in (Nord, Ost, Sud, West)
        putmarkers_until_border!(r, side)
    end
    moves!(r, Ost, steps_to_left_down_angle[2])
    moves!(r, Nord, steps_to_left_down_angle[1])
end

