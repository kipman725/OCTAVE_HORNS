%Appends triangles onto .STL file with cell array points to generate surface
%cell array needs to describe a 'strip'

function retval = DrawTriSTL(fileID, points)
  divs = length(points);
  for loop=1:(divs-1)
    p1 = points{1,loop}; %points specified quartile anti clockwise
    p2 = points{2,loop};
    p3 = points{2,loop+1};
    p4 = points{1,loop+1};
    n1 = cross(p1-p3, p2-p3);
    n2 = cross(p1-p4, p3-p4);
    n1 = n1/sqrt((n1(1)^2+n1(2)^2+n1(3)^2)); %normalize
    n2 = n2/sqrt((n2(1)^2+n2(2)^2+n2(3)^2));
    fprintf(fileID,'facet normal %e %e %e\n', n1(1), n1(2), n1(3)); %print out quartile
    fprintf(fileID,'outer loop \n');
    fprintf(fileID,'vertex %e %e %e \n', p1(1), p1(2), p1(3));
    fprintf(fileID,'vertex %e %e %e \n', p2(1), p2(2), p2(3));
    fprintf(fileID,'vertex %e %e %e \n', p3(1), p3(2), p3(3));
    fprintf(fileID,'end loop \n');
    fprintf(fileID,'end facet \n');
    fprintf(fileID,'facet normal %e %e %e\n', n2(1), n2(2), n2(3));
    fprintf(fileID,'outer loop \n');
    fprintf(fileID,'vertex %e %e %e \n', p3(1), p3(2), p3(3));
    fprintf(fileID,'vertex %e %e %e \n', p4(1), p4(2), p4(3));
    fprintf(fileID,'vertex %e %e %e \n', p1(1), p1(2), p1(3));
    fprintf(fileID,'end loop \n');
    fprintf(fileID,'end facet \n');
  endfor
  
retval = 1;  
endfunction  