using HorizonSideRobots


function get_left_down_angle!(r::Robot)::NTuple{2, Int}# перемещает робота в нижний левый угол, возвращает количество шагов
    steps_to_left_border = move_until_border!(r, West)
    steps_to_down_border = move_until_border!(r, Sud)
    return (steps_to_down_border, steps_to_left_border)
end


function get_to_origin!(r::Robot, steps_to_origin::NTuple{2, Int})
    for (i, side) in enumerate((Nord, Ost))
        moves!(r, side, steps_to_origin[i])
    end
end


function next_side(side::HorizonSide)::HorizonSide
    return HorizonSide((Int(side) + 1) % 4)
end


function inverse_side(side::HorizonSide)::HorizonSide
    inv_side = HorizonSide((Int(side) + 2) % 4)
    return inv_side
end


function along!(stop_condition::Function, robot, side) 
    while !stop_condition(side)
        move!(robot, side)
    end
end


function numsteps_along!(stop_condition, robot, side) 
    n_steps = 0
    while !stop_condition(side)
        move!(robot, side)
        n_steps += 1
    end
    return n_steps
end


function along!(stop_condition, robot, side, max_num)
    n_steps = 0
    while !stop_condition(side) && n_steps < max_num
        move!(robot, side)
        n_steps += 1
    end
    return n_steps
end


function along!(robot, side) 
    while !isborder(robot, side)
        move!(robot, side)
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

function along!(robot, side, num_steps)
    n_steps = 0
    while !isborder(robot, side) && n_steps < num_steps
        move!(robot, side)
        n_steps += 1
    end
end


function snake!(stop_condition::Function, robot, (move_side, next_row_side)::NTuple{2,HorizonSide}=(Ost,Nord))
    while !stop_condition(side) && !isborder(next_row_side)
        while !isborder(robot, move_side)
            move!(move_side)
        end

        move!(next_row_side)
        move_side = inverse_side(move_side)
    end
end


function snake!(robot, (move_side, next_row_side)::NTuple{2,HorizonSide}=(Ost,Nord))
    get_left_down_angle!(robot)
    while !isborder(next_row_side)
        while !isborder(robot, move_side)
            move!(move_side)
        end

        move!(next_row_side)
        move_side = inverse_side(move_side)
    end
end


function spiral!(stop_condition::Function, robot)
    n_steps = 1
    side = Ost
    while !stop_condition(side)
        along!(stop_condition, robot, side, n_steps)
        side = next_side(side)
        along!(stop_condition, robot, side, n_steps)
        side = next_side(side)
        n_steps +=1
    end
end

"""function spiral!(stop_condition::Function, robot, side = Nord)
    along!(side, n) = along!(() -> stop_condition(side), robot, side, n)
    n=1
    while !stop_condition(side)
        along!(side, n)
        if stop_condition(side)
            continue
        end
        side = left(side)
        along!(side, n)
        if stop_condition(side)
            continue
        end
        side = left(side)
        n += 1
    end
end"""

function shatl!(stop_condition::Function, robot::Robot, side::HorizonSide)
    if !stop_condition(side)
        move!(robot, side)
    end
end

function inverse_side(side::HorizonSide)::HorizonSide
    inv_side = HorizonSide((Int(side) + 2) % 4)
    return inv_side
end

function moves!(r::Robot, side::HorizonSide, n_steps::Int)
    for i in 1:n_steps
        move!(r, side)
    end
end

function move_until_border!(r::Robot, side::HorizonSide)::Int
    n_steps = 0
    while !isborder(r, side)
        n_steps += 1
        move!(r, side)
    end
    return n_steps
end

function putmarkers_until_border!(r::Robot, side::HorizonSide)::Int
    n_steps = 0
    while !isborder(r, side) 
        move!(r, side)
        putmarker!(r)
        n_steps += 1
    end 
    return n_steps
end

function move_putmarker!(robot::Robot, side::NTuple{2,HorizonSide})
    while !isborder(robot, side[1]) && !isborder(robot, side[2])
        move!(robot, side[1])
        move!(robot, side[2])
        putmarker!(robot)
    end
end

function move_by_markers(robot::Robot, side::NTuple{2, HorizonSide})
    while ismarker(robot)
        move!(robot, side[1])
        move!(robot, side[2])
    end
end

inverse(side::HorizonSide) = HorizonSide((Int(side)+2)%4)

inverse(side::NTuple{2, HorizonSide}) = (inverse(side[1]), inverse(side[2]))

function move_if_possible!(r::Robot, side::HorizonSide)::Bool
    if !isborder(r, side)
        move!(r, side)
        return true
    end
    return false
end

function inversed_path(path::Vector{Tuple{HorizonSide, Int}})::Vector{Tuple{HorizonSide, Int}}
    inv_path = []
    for step in path
        inv_step = (inverse_side(step[1]), step[2])
        push!(inv_path, inv_step)
    end
    reverse!(inv_path)
    return inv_path
end

function make_way!(r::Robot, path::Vector{Tuple{HorizonSide, Int}})
    for step in path
        moves!(r, step[1], step[2])
    end
end

function make_way_back!(r::Robot, path::Vector{Tuple{HorizonSide, Int}})
    inv_path = inversed_path(path)
    make_way!(r, inv_path)
end

function mark_inner_rectangle!(r::Robot)
    steps = get_left_down_angle_modified!(r)

    while isborder(r, Sud) && !isborder(r, Ost)
        move_until_border!(r, Nord)
        move!(r, Ost)
        while !isborder(r, Ost) && move_if_possible!(r, Sud) end
    end

    for sides in [(Sud, Ost), (Ost, Nord), (Nord, West), (West, Sud)]
        side_to_move, side_to_border = sides
        while isborder(r, side_to_border)
            putmarker!(r)
            move!(r, side_to_move)
        end
        putmarker!(r)
        move!(r, side_to_border)
    end

    get_left_down_angle_modified!(r)
    make_way_back!(r, steps)
end

function make_way_back!(r::Robot, path::Vector{Tuple{HorizonSide, Int}})
    inv_path = inversed_path(path)
    make_way!(r, inv_path)
end

function moves_if_possible!(r::Robot, side::HorizonSide, n_steps::Int)::Bool
    
    while n_steps > 0 && move_if_possible!(r, side)
        n_steps -= 1
    end

    if n_steps == 0
        return true
    end

    return false
end

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

function get_left_down_angle_modified!(r::Robot)::Vector{Tuple{HorizonSide, Int}}
    steps = []
    while !(isborder(r, West) && isborder(r, Sud))
        steps_to_West = move_until_border!(r, West)
        steps_to_Sud = move_until_border!(r, Sud)
        push!(steps, (West, steps_to_West))
        push!(steps, (Sud, steps_to_Sud))
    end
    return steps
end

function move_if_possible!(r::Robot, side::HorizonSide)::Bool
    if !isborder(r, side)
        move!(r, side)
        return true
    end
    return false
end

function inversed_path(path::Vector{Tuple{HorizonSide, Int}})::Vector{Tuple{HorizonSide, Int}}
    inv_path = []
    for step in path
        inv_step = (inverse_side(step[1]), step[2])
        push!(inv_path, inv_step)
    end
    reverse!(inv_path)
    return inv_path
end

function make_way!(r::Robot, path::Vector{Tuple{HorizonSide, Int}})
    for step in path
        moves!(r, step[1], step[2])
    end
end

function make_way_back!(r::Robot, path::Vector{Tuple{HorizonSide, Int}})
    inv_path = inversed_path(path)
    make_way!(r, inv_path)
end

function move_through!(r::Robot, side::HorizonSide)
    find_space!(r, side)
    move!(r, side)
end

left(side::HorizonSide)::HorizonSide = HorizonSide(mod(Int(side)-1, 4))