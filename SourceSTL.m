%James Lawson 2022
%Writes out an .STL file for a rectangular horn quarter source given the horn
%profile.

%Rules for meshing:
%Mesh elements should be ~ square (aspect ratio 0.75 - 1.25)
%Minimum of 3 mesh elements accross horn

function retval = SourceSTL(FileName, hs, h_profile, v_profile)
%Open .stl and append start info
fileID = fopen([FileName '.stl'],'w');
fprintf(fileID,'solid \n');  
 
%Adjust horn to so mouth is at 0
hs = hs = hs-hs(end);
 
%arbitary wall drawing function
P1 = [0 v_profile(1) hs(1)];
P2 = [0 0 hs(1)];
P3 = [h_profile(1) 0 hs(1)];
P4 = [h_profile(1) v_profile(1) hs(1)];
P1P2Divs = 3;
P2P3Divs = 3;
DrawWallSTL (P1, P2, P3, P4, P1P2Divs, P2P3Divs, fileID);  

fprintf(fileID,'end solid \n');
fclose(fileID);  
retval = 1;
endfunction