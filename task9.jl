include("functionsForRobot.jl")
using HorizonSideRobots
r=Robot(animate=true)

function mark_chess!(r::Robot)
    
    steps = get_left_down_angle!(r)
    to_mark = (steps[1] + steps[2]) % 2 == 0
    steps_to_ost_border = move_until_border!(r, Ost)
    move_until_border!(r, West)
    last_side = steps_to_ost_border % 2 == 1 ? Sud : Nord

    side = Nord

    while !isborder(r, Ost)
        
        while !isborder(r, side)
            if to_mark
                putmarker!(r)
            end

            move!(r, side)
            to_mark = !to_mark
        end

        if to_mark
            putmarker!(r)
        end

        move!(r, Ost)
        to_mark = !to_mark
        
        side = inverse_side(side)
    end

    while !isborder(r, last_side)
        
        while !isborder(r, side)
            if to_mark
                putmarker!(r)
            end

            move!(r, side)
            to_mark = !to_mark
        end

        if to_mark
            putmarker!(r)
        end

    end

    get_left_down_angle!(r)
    get_to_origin!(r, steps)
end