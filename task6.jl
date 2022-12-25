include("functionsForRobot.jl")
using HorizonSideRobots
r=Robot(animate=true)

function mark_perimetr_with_inner_border!(r::Robot) # подзадача а
    path = get_left_down_angle_modified!(r)
    mark_perimetr!(r)
    make_way_back!(r, path)
end



function mark_four_cells!(r::Robot) #подзадача б 
    path = get_left_down_angle_modified!(r)
    n_steps_to_sud = 0
    n_steps_to_west = 0
    for step in path
        if step[1] == Sud
            n_steps_to_sud += step[2]
        else
            n_steps_to_west += step[2]
        end
    end

    moves!(r, Ost, n_steps_to_west)
    putmarker!(r)
    move_until_border!(r, Ost)
    moves!(r, Nord, n_steps_to_sud)
    putmarker!(r)
    get_left_down_angle_modified!(r)

    moves!(r, Nord, n_steps_to_sud)
    putmarker!(r)
    move_until_border!(r, Nord)
    moves!(r, Ost, n_steps_to_west)
    putmarker!(r)
    get_left_down_angle_modified!(r)

    make_way_back!(r, path)
end