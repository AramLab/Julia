include("somefunctions.jl")

function chess!(robot, side)
    if !isborder(r, side)
        putmarker!(r)
        move!(r, side)
        chess2!(r, side)
    end
    putmarker!(r)
end

function chess2!(robot, side)
    if !isborder(robot, side)
        move!(r, side)
        chess!(robot, side)
    end
end