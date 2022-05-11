%Design example of exp-conic-conic only h horn 

%add in throat vanes

%add in ability to seperate h and v expansions in order to maximise mouth size
%in all dimensions6


%seperate out the hs vector into h and v vectors to allow differing inflection poins

throat_dia = 50.8e-3; %[m]
cutoff = 200; %initial flare cutoff frequency 
hp = 90; %target horizontal coverage angle [deg]
vp = 60; %target vertical coverage angle [deg]
xh_max = 0.9;
xv_max = 0.5;
chans = 3; %number of channels to subdivide the exponential section into
max_mouth = 1; %if one maximise the mouth size by seperating v and h flare points
min_mesh = 5e-3; %minimum distance between mesh points [m]
max_mesh = 0; %maximum distance between mesh points [m]
ang_res = 2; %target angular resolution [deg]

%Design the horn and output profiles
[hs h_profile v_profile area_profile] = HornExpHOnlyFlared (throat_dia, cutoff, hp, vp, xh_max, xv_max,
chans, max_mouth);

figure(1)
plot(hs,h_profile);
title('Horizontal horn profile');
hold on;
plot(hs,-h_profile);
ylabel('x [m]');
xlabel('Distance from throat, Z [m]');
axis("square", "equal");
hold off;

figure(2)
plot(hs,v_profile);
title('Vertical horn profile');
hold on;
plot(hs,-v_profile);
ylabel('y [m]');
xlabel('Distance from throat, Z [m]');
axis("square", "equal");
hold off;

figure(3)
title('Area profile');
semilogy(hs,area_profile);
ylabel('Area [m^2]');
xlabel('Distance from throat, Z [m]');

[hs_cull, h_profile_cull, v_profile_cull] = PointsCull (hs, h_profile, v_profile, min_mesh, max_mesh, ang_res)

retval = RectHornSTL2('max_mouth_200Hz_horn', hs_cull, h_profile_cull, v_profile_cull);
SourceSTL('max_mouth_200Hz_source', hs_cull, h_profile_cull, v_profile_cull);
RectHornInterface ('max_mouth_200Hz_int', h_profile_cull, v_profile_cull, 50e-3);