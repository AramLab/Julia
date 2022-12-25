include("somefunctions.jl")

function fibonachi(n)
    if n in (1,2)
        return 1
    end
    fibonachi(n-1) + fibonachi(n-2)
end