clc; clear all;close all;
wing_y = [0.083	0.089	0.095	0.101	0.107	0.113	0.119	0.125	0.131	0.137	0.1739	0.2417	0.3094	0.3772	0.445	0.5128	0.5806	0.6483	0.7161	0.7512	0.7538	0.7562	0.7588	0.7625	0.7675	0.7725	0.7775	0.7825	0.7875	0.7925	0.7975	0.805	0.815];
M_b_hrz =[5.0169	4.9263	4.836	4.7462	4.6569	4.5682	4.4801	4.3927	4.3059	4.2199	3.6968	2.8415	2.1015	1.48	0.976	0.5857	0.3031	0.1201	0.0258	0.0146	0.0137	0.0128	0.012	0.0106	0.0088	0.0071	0.0055	0.0041	0.003	0.002	0.0013	0.0004	0];

% Fit a parabola (degree 2 polynomial)
coefficients = polyfit(wing_y, M_b_hrz, 2);

% Evaluate the parabola
wing_y_fit = linspace(min(wing_y), max(wing_y), 100); % Generate finer points for smooth curve
M_b_fit = polyval(coefficients, wing_y_fit);

% Display coefficients
disp('Fitted Parabolic Coefficients:');
disp(['a = ', num2str(coefficients(1))]);
disp(['b = ', num2str(coefficients(2))]);
disp(['c = ', num2str(coefficients(3))]);
%11.71*"x"^2 -17.28*"x" +6.36
% Plot the original data and fitted curve
figure;
plot(wing_y, M_b_hrz, 'ro', 'MarkerSize', 8, 'DisplayName', 'Original Data'); % Original data
hold on;
plot(wing_y_fit, M_b_fit, 'b-', 'LineWidth', 2, 'DisplayName', 'Parabolic Fit'); % Fitted curve
grid on;
xlabel('Spanwise Position (y) [m]');
ylabel('Bending Moment (M_b) [Nm]');
title('Parabolic Curve Fit for Bending Moment');
legend('Location', 'Best');