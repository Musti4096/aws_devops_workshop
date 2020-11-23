def makeBox(n):
  times =0 
  if n==1:
    print('#')
  else:
    top="#"*n
    middle="#" + " "*(n-2) + "#"
    bottom= "#"*n
  print(top)
  while times < n-2:
    print(middle)
    times+=1
  print(bottom)
makeBox(4)