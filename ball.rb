w=80;h=24;n=5;b=(0...n).map{|i|{x:rand(w),y:rand(h/2),vx:rand(-1.0..1.0),vy:0,c:31+i%7,s:["O","@","*"].sample}}
loop{print"\e[2J\e[H";b.each{|o|o[:vy]+=0.2;o[:x]+=o[:vx];o[:y]+=o[:vy]
o[:x]=[w-1,o[:x],0].sort[1];o[:vx]*=-0.9 if o[:x]<1||o[:x]>w-2
o[:y]=[h-1,o[:y],0].sort[1];o[:vy]*=-0.8 if o[:y]>h-2
print"\e[#{o[:y].to_i+1};#{o[:x].to_i+1}H\e[#{o[:c]}m#{o[:s]}\e[0m"}
print"\e[#{h};1H\e[37m"+"-"*w;sleep 0.05}
