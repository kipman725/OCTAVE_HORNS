## Author: James Lawson
## Created: 2022-03-31

#Generates the interface box infront of the horn (open pizza box of Idepth
#Normals point into the horn
#Box is only one quadrant to make use of symetry
#make 3 elements deep
#then make other elements square 

function retval = RectHornInterface (FileName, h_profile, v_profile, Idepth)
%Open .stl and append start info
fileID = fopen([FileName '.stl'],'w');
fprintf(fileID,'solid \n');  

ElementSquare = Idepth/3; %size of element square
Velements = round(v_profile(end)/ElementSquare);
Helements = round(h_profile(end)/ElementSquare);

%Generate dummy non expanding horn for mouth
hs = 0:Idepth/3:Idepth;
h_profile = ones(1,length(hs))*h_profile(end);
v_profile = ones(1,length(hs))*v_profile(end);

%go anti clockwise to obay right hand rule
%writing out quartile segments but stl only supports triangles
%normals point inwards into interior subdomain in AKABAK
for loop=1:(length(h_profile)-1)
    divs = Helements;
    %Draw  half top surface
    x0 = 0:h_profile(loop)/(divs-1):h_profile(loop);
    x1 = 0:h_profile(loop+1)/(divs-1):h_profile(loop+1);
    points = cell(2, divs); %prealocate
    for loop2=1:divs 
      points{1,loop2} = [x0(loop2) v_profile(loop) hs(loop)];
      points{2,loop2} = [x1(loop2) v_profile(loop+1) hs(loop+1)];
    end;
    DrawTriSTL(fileID, points); %append triangles
    
    %Draw side +x side half surface
    divs = Velements;
    
    y0 = v_profile(loop):-v_profile(loop)/(divs-1):0;
    y1 = v_profile(loop+1):-v_profile(loop+1)/(divs-1):0;
    points = cell(2, divs); %prealocate
    for loop2=1:divs 
      points{1,loop2} = [h_profile(loop) y0(loop2) hs(loop)];
      points{2,loop2} = [h_profile(loop+1) y1(loop2) hs(loop+1)];
    end;
    DrawTriSTL(fileID, points); %append triangles
end


%Draw front face 
P1 = [0 v_profile(1) hs(end)];
P2 = [0 0 hs(end)];
P3 = [h_profile(end) 0 hs(end)];
P4 = [h_profile(end) v_profile(end) hs(end)];
P1P2Divs = Velements;
P2P3Divs = Helements;
DrawWallSTL (P1, P2, P3, P4, P1P2Divs, P2P3Divs, fileID);  



fprintf(fileID,'end solid \n');
fclose(fileID);  
retval = 1;


endfunction
