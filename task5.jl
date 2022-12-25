include("functionsForRobot.jl")
using HorizonSideRobots
r=Robot(animate=true)


function mark_external_internal(robot)
    back_path = move_to_angle!(robot)
    mark_external_rect!(robot)
    find_internal_border!(robot)
    move_to_internal_sudwest!(robot)
    mark_internal_rect!(robot)
    move_to_back!(robot, back_path)
end

function move_to_angle!(robot)
    return (side = Nord, num_steps = 
    numsteps_along!(robot, Sud)), 
    (side = Ost, num_steps = 
    numsteps_along!(robot, West)), 
    (side = Nord, num_steps = 
    numsteps_along!(robot, Sud))
end

function move_to_back!(robot, back_path)
    for next in back_path
        along!(robot, next.side, next.num_steps)
    end
end

function find_internal_border!(robot)
    function find_in_row(side)
        along!(robot, next.side, next.num_steps)
    end
end

function find_internal_border!(robot)
    function find_in_row(side)
        while !isborder(robot, Nord) && !isborder(robot, side)
            move!(robot, side)
        end
    end
    side = Ost
    find_in_row(side)
    while !isborder(robot, Nord)
        move!(robot, Nord)
        side = inverse(side)
        find_in_row(side)
    end
end

function move_to_internal_sudwest!(robot)
    while isborder(robot, Nord)
        move!(robot, West)
    end
end

function mark_external_rect!(robot)
    for side in (Ost, Nord, West, Sud)
        mark_along!(robot, side)
    end
end

function mark_along!(robot, side)
    while !isborder(robot, side)
        move!(robot, side)
        putmarker!(robot)
    end
end

function mark_internal_rect!(robot)
    for side in (Ost, Nord, West, Sud)
        mark_along!(robot, side, left(side))
    end
end

function mark_along!(robot, move_side, border_side) 
    while isborder(robot, border_side)
        move!(robot, move_side)
        putmarker!(robot)
    end
end

function numsteps_along!(robot, side) 
    n_steps = 0
    while !isborder(robot, side)
        move!(robot, side)
        n_steps += 1
    end
    return n_steps
end

function along!(robot, direct, num_steps)::Nothing
    for _ in 1:num_steps
        move!(robot, direct)
    end
end

left(side::HorizonSide)::HorizonSide = HorizonSide(mod(Int(side)-1, 4))

inverse(side::HorizonSide) = HorizonSide((Int(side)+2)%4)

inverse(side::NTuple{2, HorizonSide}) = (inverse(side[1]), inverse(side[2]))