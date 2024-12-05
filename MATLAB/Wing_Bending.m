clc; clear all; close all;
% Imported data from xflr5
wing_y = [-0.815	-0.805	-0.7975	-0.7925	-0.7875	-0.7825	-0.7775	-0.7725	-0.7675	-0.7625	-0.7588	-0.7562	-0.7538	-0.7512	-0.7161	-0.6483	-0.5806	-0.5128	-0.445	-0.3772	-0.3094	-0.2417	-0.1739	-0.137	-0.131	-0.125	-0.119	-0.113	-0.107	-0.101	-0.095	-0.089	-0.083  	0   0.083	0.089	0.095	0.101	0.107	0.113	0.119	0.125	0.131	0.137	0.1739	0.2417	0.3094	0.3772	0.445	0.5128	0.5806	0.6483	0.7161	0.7512	0.7538	0.7562	0.7588	0.7625	0.7675	0.7725	0.7775	0.7825	0.7875	0.7925	0.7975	0.805	0.815];
M_b_hrz =    [    0 	0.0004	0.0013	0.002	0.003	0.0041	0.0055	0.0071	0.0088	0.0106	0.012	0.0128	0.0137	0.0146	0.0258	0.1201	0.3031	0.5857	0.976	1.48	2.1015	2.8414	3.6968	4.2199	4.3059	4.3927	4.4801	4.5682	4.6569	4.7462	4.836	4.9263	5.0169	5.0169  5.0169	4.9263	4.836	4.7462	4.6569	4.5682	4.4801	4.3927	4.3059	4.2199	3.6968	2.8415	2.1015	1.48	0.976	0.5857	0.3031	0.1201	0.0258	0.0146	0.0137	0.0128	0.012	0.0106	0.0088	0.0071	0.0055	0.0041	0.003	0.002	0.0013	0.0004	0];
chord =  [ 0.08	    0.09	0.0975	0.1025	0.1075	0.1125	0.1175	0.1225	0.1275	0.1325	0.1362	0.1387	0.1412	0.1437	0.1492	0.1575	0.1658	0.1742	0.1825	0.1908	0.1992	0.2075	0.2158	0.2215	0.2245	0.2275	0.2305	0.2335	0.2365	0.2395	0.2425	0.2455	0.2485	0.2485  0.2485	0.2455	0.2425	0.2395	0.2365	0.2335	0.2305	0.2275	0.2245	0.2215	0.2158	0.2075	0.1992	0.1908	0.1825	0.1742	0.1658	0.1575	0.1492	0.1437	0.1412	0.1387	0.1362	0.1325	0.1275	0.1225	0.1175	0.1125	0.1075	0.1025	0.0975	0.09	0.08];

% Veritcal Flight Bending Moment
M_b_vrt = 9.81*1*(0.815-abs(wing_y)) ;

d_o = 0.012; % Outer diameter of the tube [m]
d_i = 0.010; % Inner diameter of the tube [m]
A_tube = pi * (d_o^2 - d_i^2) / 4; % Tube Area [m^2]
I_tube = pi * (d_o^4 - d_i^4) / 64; % Tube moment of inertia [m^4]
E_tube = 39e9; % Elastic modulus of CFRP [Pa]
d_st = (1.22e-2) * chord; % Distance btw General Neutral Axis and Tube Neutral Axis [m]
I_tube_trasformed = I_tube + A_tube*d_st.^2; % Transformed I of shell
L_tube = 0.5; % Length of the tube in half of the wing [m]

I_shell = (55082.565563e-12/0.25^3) * chord.^3; % Shell moment of inertia [m^4]
E_shell = 1.951e9; % Elastic modulus of PLA [Pa]


% ---------Flexural Ridigity Computation---------
EI = zeros(0,length(wing_y));
for i = 1 : length(wing_y)
    if abs(wing_y(i)) < 0.084
        EI(i) =  E_tube*I_tube;
    elseif abs(wing_y(i)) < L_tube
        EI(i) = E_shell*I_shell(i) + E_tube*I_tube_trasformed(i);
    else
        EI(i) = E_shell .* I_shell(i);
    end
end
% ---------Horizontal Flight Deflection---------

% First integration: Calculate slope
slope = cumtrapz(wing_y, M_b_hrz ./ EI);
% Adjust slope to enforce boundary condition: slope(0) = 0
slope = slope - slope(find(wing_y == 0, 1));
% Second integration: Calculate deflection
deflection = cumtrapz(wing_y, slope);
% Adjust deflection to enforce boundary condition: deflection(0) = 0
deflection_hrz = (deflection - deflection(find(wing_y == 0, 1))).*1000;

% ---------Vertical Flight Deflection---------

% First integration: Calculate slope
slope = cumtrapz(wing_y, M_b_vrt ./ EI);
% Adjust slope to enforce boundary condition: slope(0) = 0
slope = slope - slope(find(wing_y == 0, 1));
% Second integration: Calculate deflection
deflection = cumtrapz(wing_y, slope);
% Adjust deflection to enforce boundary condition: deflection(0) = 0
deflection_vrt = (deflection - deflection(find(wing_y == 0, 1))).*1000;

% Plot bending moment
figure;
subplot(2, 1, 1);
plot(wing_y, M_b_hrz, 'b-', 'LineWidth', 2);
hold on;
plot(wing_y, M_b_vrt, 'r-', 'LineWidth', 2)
grid on;
xlabel('Spanwise Position [m])');
ylabel('Bending Moment [Nm]');
title('Bending Moment Distribution');
legend("during Horizontal Flight","during Vertical Flight",Location="best");
% Plot deflection
subplot(2, 1, 2);
plot(wing_y, deflection_hrz, 'b-', 'LineWidth', 2);
hold on;
plot(wing_y, deflection_vrt, 'r-', 'LineWidth', 2);
grid on;
xlabel('Spanwise Position [m]');
ylabel('Deflection [mm]');
title('Deflection Distribution');
legend("during Horizontal Flight","during Vertical Flight",Location="best");



