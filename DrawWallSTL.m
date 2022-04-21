#Draws a divided plane in an STL file using 4 verticies [x y z]
#[p1 p4]
#[p2 p3]
#P1P2Divs = mumber of divisions between P1 and P2, E.G 2 generates two quartiles
#P2P3Divs = number of divisions between P2 and P3
#fileID is open file handle
## Author: James Lawson
## Created: 2022-04-06

function retval = DrawWallSTL (P1, P2, P3, P4, P1P2Divs, P2P3Divs, fileID)

#Generate all the points of the wall
DeltaP1P2 = (P2-P1)/P1P2Divs; %how far to move
DeltaP2P3 = (P3-P2)/P2P3Divs;
for loop2=1:P1P2Divs
  points = cell(2, P2P3Divs+1); %prealocate
  for loop=1:(P2P3Divs+1)
    points{1,loop} = [P1+((loop-1)*DeltaP2P3)+(loop2*DeltaP1P2)];
    points{2,loop} = [P1+((loop-1)*DeltaP2P3)+((loop2-1)*DeltaP1P2)];
  end
  retval = DrawTriSTL(fileID, points);
end
retval = 1;


endfunction
