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

%TODO:
%1) allow seperate horizonal and vertical flr_ang (E.G allow unflared horizonal
% with flr_ang = 1)
%2) add option to maximise the mouth size in both the vertical and horizonal
%3) add the option to divide the throat into smaller segments to mitigate HF 
% beaming and export their curves
%4) take into account the flare divider thickness in some way?

function [hs h_profile v_profile area_profile] = HornExpHOnlyFlared (throat_dia, cutoff, hp, vp, xh_max, xv_max
  , chans, max_mouth)

%inputs
c = 344; %speed of sound [m/s]
flr_pt_v = 2/3; %fraction of conical length to begin flare (1 disables flare)
flr_pt_h = 3/4; 
flr_ang = 5/3; %multiplier of angle for flare (horn book suggestion to avoid flat baffle)
lr = 1e-3; %initial length resolution
throat_square_area = throat_dia^2; %[mm] 

%Exponentional prototype calculations 
k = 2.5e4; %empirical constant (Keele)
m = 4*pi*cutoff/c; %flare rate of exponential prototype
exp_length = log(2*throat_dia*tand(hp/2)/(m*throat_square_area))/m; %Match wall angle to first conic

%Calculate maximum horn length if constrained by the vertical mouth dimension
v_length_max = (xv_max/2-throat_dia/2)/(flr_pt_v*tand(vp/2)+(1-flr_pt_v)*tand(flr_ang*vp/2));

%Calculate maximum horn length if constrained by the horizontal mouth dimension
A_end_exp = throat_square_area*exp(m*exp_length);
h_end_exp =  A_end_exp/throat_dia; %width at end of exponential section
h_length_max = (xh_max/2-h_end_exp/2)/(flr_pt_h*tand(hp/2)+(1-flr_pt_h)*tand(flr_ang*hp/2));


%Constrain length of horn after exponential section
conic_length = min(h_length_max, v_length_max);
hl = exp_length+conic_length;
ltec_h = exp_length+conic_length*flr_pt_h;%length to end of first conic section 
ltec_v = exp_length+conic_length*flr_pt_v;

%define sampling vector
lr_mod = hl/ceil(hl/lr); %modify resolution so it matches start and end
hs = 0:lr_mod:hl;

if ((max_mouth = 0) || (v_length_max < h_length_max))

%Trace out profiles (may want seperate export for segments?)
es0_h_profile = throat_square_area*exp(m*exp_length)/throat_dia/2; %calculate the h_profile and v_profiles at the end of each section
es0_v_profile = throat_dia/2;
es1_h_profile = es0_h_profile+(conic_length*flr_pt_h)*tand(hp/2);
es1_v_profile = es0_v_profile+(conic_length*flr_pt_v)*tand(vp/2);
es2_h_profile = es1_h_profile+(conic_length*(1-flr_pt_h)*tand(hp/2*flr_ang));
es2_v_profile = es1_v_profile+(conic_length*(1-flr_pt_v)*tand(vp/2*flr_ang));
h_profile = zeros(1,length(hs)); %prealocate
v_profile = h_profile;
for loop=1:length(hs)
  if (hs(loop) < exp_length) %exponential section
    h_profile(loop) = throat_square_area*exp(m*hs(loop))/throat_dia/2;
  elseif (hs(loop) < (exp_length+conic_length*flr_pt_h)) %first conic (h)
    h_profile(loop) = es0_h_profile+(hs(loop)-exp_length)*tand(hp/2);
  else %flare conic
    h_profile(loop) = es1_h_profile+(hs(loop)-ltec_h)*tand(hp/2*flr_ang);
  end  
  if (hs(loop) < exp_length) %exponential section
    v_profile(loop) = throat_dia/2;
  elseif (hs(loop) < (exp_length+conic_length*flr_pt_v)) %first conic (v)
    v_profile(loop) = es0_v_profile+(hs(loop)-exp_length)*tand(vp/2);
  else %flare conic
    v_profile(loop) = es1_v_profile+(hs(loop)-ltec_v)*tand(vp/2*flr_ang);;
  end  
end

else %Maximise mouth size by starting of the vertical flare early (in exp section)
%this is only posible if the horn conic length isn't already constrained by the
%vertical flare. 
P1_v = hl-v_length_max; %start vertical conic
P2_v = hl-v_length_max*(1-flr_pt_v); %start of vertical flare (P2 and P3 can have variable order?)
P1_h = exp_length; %start of horizonal conic 
P2_h = hl-h_length_max*(1-flr_pt_h); %start of horizonal flare

%Trace out profiles (may want seperate export for segments?)
es0_h_profile = throat_square_area*exp(m*exp_length)/throat_dia/2; %calculate the h_profile and v_profiles at the end of each section
es0_v_profile = throat_dia/2;
es1_h_profile = es0_h_profile+(conic_length*flr_pt_h)*tand(hp/2);
es1_v_profile = es0_v_profile+(v_length_max*flr_pt_v)*tand(vp/2); %note changed from non max mouth
es2_h_profile = es1_h_profile+(conic_length*(1-flr_pt_h)*tand(hp/2*flr_ang));
es2_v_profile = es1_v_profile+(v_length_max*(1-flr_pt_v)*tand(vp/2*flr_ang)); %note changed from non max mouth
h_profile = zeros(1,length(hs)); %prealocate
v_profile =h_profile;
for loop=1:length(hs)
  if (hs(loop) < P1_h) %exponential section
    h_profile(loop) = throat_square_area*exp(m*hs(loop))/throat_dia/2;
  elseif (hs(loop) < P2_h) %first conic
    h_profile(loop) = es0_h_profile+(hs(loop)-exp_length)*tand(hp/2);
  else %flare conic
    h_profile(loop) = es1_h_profile+(hs(loop)-ltec_h)*tand(hp/2*flr_ang);
  end    
  if (hs(loop) < P1_v) 
    v_profile(loop) = throat_dia/2;
  elseif (hs(loop) < P2_v) %first conic
    v_profile(loop) = es0_v_profile+(hs(loop)-P1_v)*tand(vp/2);
  else %flare conic
    v_profile(loop) = es1_v_profile+(hs(loop)-P2_v)*tand(vp/2*flr_ang);
  end    
end
end

area_profile = h_profile.*v_profile*4;

endfunction
