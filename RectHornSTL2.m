%James Lawson 2022
%Writes out an .STL file for a rectangular horn quarter given the horizontal and 
%vertical profile.  The horn is adjusted such that its mouth is at z = 0.  

%This is an improved version that atttempts to mesh the horn with correct size
%elements.
%Rules for meshing:
%Mesh elements should be ~ square (aspect ratio 0.75 - 1.25)
%Minimum of 3 mesh elements accross horn

function retval = RectHornSTL2(FileName, hs, h_profile, v_profile)
%Open .stl and append start info
fileID = fopen([FileName '.stl'],'w');
fprintf(fileID,'solid \n');  

%Adjust horn to so mouth is at 0
hs = hs = hs-hs(end);
 
%go anti clockwise to obay right hand rule
%writing out quartile segments but stl only supports triangles
%normals point inwards into interior subdomain in AKABAK
for loop=1:(length(h_profile)-1)
    %Work out how many divisions we need to make surface have the correct
    %max edge length 
    %divs = ceil(h_profile(loop+1)/max_edge);
    
    dist_seg = abs(hs(loop+1)-hs(loop));
    divs = max(3,  ceil(h_profile(loop)/dist_seg/1.5))+1;
    
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
    %divs = ceil(v_profile(loop+1)/max_edge);
    divs = max(3,  ceil(v_profile(loop)/dist_seg/1.5))+1;
    
    y0 = v_profile(loop):-v_profile(loop)/(divs-1):0;
    y1 = v_profile(loop+1):-v_profile(loop+1)/(divs-1):0;
    points = cell(2, divs); %prealocate
    for loop2=1:divs 
      points{1,loop2} = [h_profile(loop) y0(loop2) hs(loop)];
      points{2,loop2} = [h_profile(loop+1) y1(loop2) hs(loop+1)];
    end;
    DrawTriSTL(fileID, points); %append triangles
end
fprintf(fileID,'end solid \n');
fclose(fileID);  
retval = 1;

endfunction