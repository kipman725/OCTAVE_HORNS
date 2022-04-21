#Designs a horn that has no initial vertical expansion, initial exponential
#area expansion in the horizonal.  When the slope of the exponential horizonal
#expansion matches the desired horizontal coverage angle the expansion becomes
#as a conventional conical horn.  The mouth has a conventional mouth flare for 
# the final part of the horn.

#throat_dia - diameter of throat in [m] E.G 50.8e-3 is 2 inches.
#cutoff - cutoff frequency of exponential section [Hz]
#hp - target horizontal coverage angle [degrees]
#vp - target vertical coverage angle [degrees]
#xh_max - maximum horizontal dimension [m]
#xv_max - maximum vertical dimension [m]
#the horn will be constrained in mouth size by the maximum horizontal or vertical
#dimension with the other dimension been determined by the coverage target

## Author: James Lawson
## Created: 2022-04-07

function [hs h_profile v_profile area_profile] = HornExpHOnlyFlared (throat_dia, cutoff, hp, vp, xh_max, xv_max)
lr = 1e-3; %length resolution of horn [m]
c = 344; %speed of sound [m/s]


%inputs
flr_pt = 2/3; %fraction of conical length to begin flare
flr_ang = 5/3; %multiplier of angle for flare (horn book suggestion to avoid flat baffle)
%flr_ang = 1;

throat_square_area = throat_dia^2; %[mm] 



%Set mouth dimension to maximum posible
%xh = min((vp/hp)*xv_max, xh_max);
%xv = hp/vp*xh;

%Exponentional prototype calculations 
k = 2.5e4; %empirical constant (Keele)
%A_end = xv*xh; %mouth area
m = 4*pi*cutoff/c; %flare rate of exponential prototype

%Calculate how long the exponential prototype is for its wall angle to match
%the horizonal opening angle
exp_length = log(2*throat_dia*tand(hp/2)/(m*throat_square_area))/m;

%Calculate maximum horn length if constrained by the vertical mouth dimension
v_length_max = (xv_max/2-throat_dia/2)/(flr_pt*tand(vp/2)+(1-flr_pt)*tand(flr_ang*vp/2));

%Calculate maximum horn length if constrained by the horizontal mouth dimension
A_end_exp = throat_square_area*exp(m*exp_length);
h_end_exp =  A_end_exp/throat_dia; %width at end of exponential section
h_length_max = (xh_max/2-h_end_exp/2)/(flr_pt*tand(hp/2)+(1-flr_pt)*tand(flr_ang*hp/2));

%Constrain length of horn after exponential section
conic_length = min(h_length_max, v_length_max);
hl = exp_length+conic_length;

%Trace out profiles (may want seperate export for segments?)
hs = 0:lr:hl;
for loop=1:length(hs)
  if (hs(loop) < exp_length) %exponential section
    area_profile(loop) = throat_square_area*exp(m*hs(loop));
    h_profile(loop) = area_profile(loop)/throat_dia/2;
    v_profile(loop) = throat_dia/2;
  elseif (hs(loop) < (exp_length+conic_length*flr_pt)) %first conic
    %h_profile(loop) = h_profile(loop-1)+(hs(loop)-hs(loop-1))*tand(hp/2);
    h_profile(loop) = A_end_exp/throat_dia/2+(hs(loop)-exp_length)*tand(hp/2);
    v_profile(loop) = throat_dia/2+(hs(loop)-exp_length)*tand(vp/2);
    area_profile(loop) = h_profile(loop)*v_profile(loop)*4;
  else
    h_profile(loop) = h_profile(loop-1)+(hs(loop)-hs(loop-1))*tand(hp/2*flr_ang);
    v_profile(loop) = v_profile(loop-1)+(hs(loop)-hs(loop-1))*tand(vp/2*flr_ang);
    area_profile(loop) = h_profile(loop)*v_profile(loop)*4;
  end  
end


endfunction
