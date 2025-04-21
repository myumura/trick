w=80;h=24;f=[];m=50
loop{
  f<<{x:rand(w),y:0,s:0.1+rand*0.3,c:["*",".","❄","❅","❆"].sample} if f.size<m&&rand<0.3
  print"\e[2J\e[H"
  s=Array.new(h){" "*w}
  f.each{|n|
    n[:y]+=n[:s];n[:x]+=rand(-0.3..0.3)
    n[:x]=[[n[:x],0].max,w-1].min
    if n[:y]>=h
      n[:y]=0;n[:x]=rand(w)
    end
    s[n[:y].to_i][n[:x].to_i]=n[:c] if n[:y].to_i<h
  }
  puts s
  sleep 0.1
}
