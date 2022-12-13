include("functionsForRobot.jl")
using HorizonSideRobots


#Задача 15

function find_space!(r::Robot, side_to_wall::HorizonSide)
    n_steps = 1
    side = next_side(side_to_wall)

    while isborder(r, side_to_wall)
        for _ in 1:n_steps
            shatl!( _ -> !isborder(r, side_to_wall), r, side)
        end
        side = inverse_side(side)
        n_steps += 1
    end

end

#Задача 16

function find_marker!(r::Robot)
    tmp = (side::HorizonSide) -> ismarker(r)
    spiral!( tmp, r)
end

#задача 18
function move_until_border_recursive!(r::Robot, side::HorizonSide)
    if !isborder(r, side)
        move!(r, side)
        move_until_border_recursive!(r, side)
    end
end


#Задча 19
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

#Задача 20
function get_on_through_rec!(r::Robot, side::HorizonSide, n_steps::Int = 0)
    if isborder(r, side)
        move!(r, next_side(side))
        n_steps += 1
        get_on_through_rec!(r, side, n_steps)
    else
        move!(r, side)
        along!(r, inverse_side(next_side(side)), n_steps)
    end
end


#задача 26

#а 

function get_fibbonachi(n::Int)::Int
    if n == 1 || n == 2
        return 1
    end

    a = 1
    b = 1
    for i in 3:n
        tmp = a + b
        a, b = b, tmp
    end

    return b
end

#б

function get_fibbonachi_rec(n::Int)::Int
    if n == 1 || n == 2
        return 1
    end

    return get_fibbonachi_rec(n-1) + get_fibbonachi_rec(n - 2)
end


#Задача 25

function mark_chess_rec!(r::Robot, side::HorizonSide, to_mark = true)
    if to_mark
        putmarker!(r)
    end

    if !isborder(r, side)
        move!(r, side)
        to_mark = !to_mark
        mark_chess_rec!(r, side, to_mark)
    end
end

#а 
function mark_chess_pos!(r::Robot, side::HorizonSide)
    mark_chess_rec!(r, side)
end
#б

function mark_chess_negative!(r)
    mark_chess_rec!(r, side, false)
end


#Задача 23

function tail_function(a::Vector{Any})
    if length(a) == 1
        return a[1]
    end

    b = []
    for i in 2:length(a)
        push!(b, a[i])
    end

    return a[1] + tail_function(b)
end