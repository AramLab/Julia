function num_horizontal_borders!(robot)
    back_path = move_to_angle!(robot)
    side = Ost
    num_borders = num_horizontal_borders!(robot, side)
    while !isborder(robot, Nord)
        move!(robot, Nord)
        side = inverse(side)
        num_borders += num_horizontal_borders!(robot,side)
    end
    move!(robot, back_path)
    return num_borders
end
    
function num_horizontal_borders!(robot, side) 
    num_borders = 0
    state = 0
    while !isborder(robot, side)
        move!(robot, side)
        if state == 0
            if isborder(robot, Nord) == true
        state == 1
            end
        else 
            if isborder(robot, Nord) == false
                state = 0
                num_borders += 1
            end
        end
    end
    return num_borders
end