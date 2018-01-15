def sqroot(n)
  return 1 if n == 1
  return 2 if n == 4
  lower = 0
  uppper = n/2
  idx = n/4
   while true
   case idx * idx <=> n
     when -1
       lower = idx
     when 0
       return idx
     when 1
       upper = idx
   end
   idx = (upper - lower)/ 2 + lower
   end
 end