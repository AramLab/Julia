include("functionsForRobot.jl")
using HorizonSideRobots
r=Robot(animate=true)

function find_passage(r::Robot)
    n=0; 
    side=Ost
    while isborder(r,Nord)==true 
        n+=1
        moves!(r,side,n)
        side=inverse(side)
    end
end
moves!(r,side,num_steps)=for _ in 1:num_steps move!(r,side) end
inverse(side::HorizonSide)=HorizonSide(mod(Int(side)+2,4))