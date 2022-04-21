%Design example of exp-conic-conic only h horn 

%add in throat vanes

%add in ability to seperate h and v expansions in order to maximise mouth size
%in all dimensions

%Horn is not reaching size constraint?
throat_dia = 50.8e-3;
cutoff = 150;
hp = 90;
vp = 60;
xh_max = 0.9;
xv_max = 0.5;

[hs h_profile v_profile area_profile] = HornExpHOnlyFlared (throat_dia, cutoff, hp, vp, xh_max, xv_max);


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

retval = RectHornSTL2('ecch_150_horn', hs, h_profile, v_profile);
SourceSTL('ecch_150_source', hs, h_profile, v_profile);
RectHornInterface ('ecch_150_int', h_profile, v_profile, 50e-3);