## Author: James Lawson
## Created: 2022-04-29
%Tested with 1e-3 [m] mesh resolution input
%min_mesh : minimum distance between mesh points [m]  try 5e-3
%ang_res : the change in angle that results in a mesh point [deg] (try 2 degrees)

function [hs_cull, h_profile_cull, v_profile_cull] = PointsCull (hs, h_profile, v_profile, min_mesh, max_mesh, ang_res)

%Calculate derivatives
h_der = gradient(h_profile,hs);
v_der = gradient(v_profile,hs);
h_der2 = gradient(h_der,hs);
v_der2 = gradient(v_der,hs);

%Wall angle
h_wa = atand(h_der);
v_wa = atand(v_der);

%Generate points of interest using the horizontal and vertical wall angles 
POI = 1; %First point is a point of interest
last_ang_h = h_wa(1);
last_ang_v = v_wa(1);
for loop=2:length(hs) %mesh using angular critera
  if ((abs(last_ang_h-h_wa(loop)) >= ang_res) || (abs(last_ang_v-v_wa(loop)) >= ang_res))
      last_ang_h = h_wa(loop);
      last_ang_v = v_wa(loop);
      POI = [POI loop]; 
  endif
end
if (POI(end) ~= length(hs)) %append end of horn if not already there 
  POI = [POI length(hs)];
endif

%Go through POI and delete any that are within the minimum mesh distance of another point
if (length(POI) > 2)
  index = 2; %Exclude first and last points 
  while (index < (length(POI)-1))  
    dfl = abs(hs(POI(index))-hs(POI(index+1)));
    if (dfl < min_mesh)
      POI(index+1) = []; %remove point 
    else
      index = index+1; %allow progression
    endif
  end
end

%Go through POI and check/correct for maximum mesh distance
%ignore parameter if 0
hs_cull = hs(POI);
hs_cull_new = hs_cull;
index = 1;
for loop=1:(length(POI)-1)
  dist = hs_cull(loop+1)-hs_cull(loop);
  if (dist > max_mesh)
    sec_length = hs_cull(loop+1)-hs_cull(loop);
    res_mod =  sec_length/ceil(sec_length/max_mesh);
    new_points = hs_cull(loop)+res_mod:res_mod:hs_cull(loop+1)-res_mod;
    hs_cull_new = [hs_cull_new new_points];
  endif
end
hs_cull = sort(hs_cull_new);

%Check that we are not going to get aspect ration >1.5 triangles by having too
%great HS compared to the V and H profiles

%Generate new profiles
h_profile_cull = interp1(hs, h_profile, hs_cull, 'linear');
v_profile_cull = interp1(hs, v_profile, hs_cull, 'linear');

%Debug
figure(4)
plot(hs, h_profile);
hold;
plot(hs, v_profile);
scatter(hs_cull, h_profile_cull);
scatter(hs_cull, v_profile_cull);
hold off;


endfunction
