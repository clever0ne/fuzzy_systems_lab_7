clc; clear; close all;

Unom = 24; 
Wnom = 2 * pi / 60 * 9690;
Mnom = 57.8e-3;
Inom = 2.76;

Widle = 2 * pi / 60 * 10700;
Ioc = 65.7e-3;

R = 0.74;
L = 0.129e-3;

Jm = 21.4e-7; 
Jgb = 1.28e-7; 
k = 371250/3610;
n = 0.75;

J = k^2 * Jm + Jgb; 
kM = 21.4e-3;
kV = 445;
kE = 60 / (2 * pi * kV);
kF = n * k^2 * kM * Ioc/Widle;

pd = 3*pi/4;
Ku = Unom;
Ke = 1/pd;
Kw = 0.1;

ml = 0.1;
g  = 9.81;
l  = 1;

count = 21;
xmin = -1;
xmax =  1;
ymin = -1;
ymax =  1;

x1 = linspace(xmin, xmax, count);
x2 = linspace(xmin, xmax, count);
y = linspace(ymin, ymax, count);
x = reshape(cat(3, repmat(x1, length(x2), 1)', ...
                   repmat(x2, length(x1), 1)), [], 2, 1);

system = '../system/motor_drive_model.slx';
sim(system, 0.1);

t = data1(:, 1);
i = data1(:, 2);
w = data2(:, 2);
u = data3(:, 2);
m = data4(:, 2);

print_step_response_plot('voltage',  t, [], u, '', 'voltage_step_response.emf' );
print_step_response_plot('moment',   t, [], m, '', 'moment_step_response.emf'  );
print_step_response_plot('current',  t, [], i, '', 'current_step_response.emf' );
print_step_response_plot('angspeed', t, [], w, '', 'angspeed_step_response.emf');

time = 10;
fis = readfis('../model/mamdani_trimf_5in_trimf_5out.fis');
system = '../system/motor_drive_control.slx';
sim(system, time);

t  = data1(:, 1);
i  = data1(:, 2);
w  = data2(:, 2);
u  = data3(:, 2);
m  = data4(:, 2);
pd = data5(:, 2);
p  = data5(:, 3);
e  = data6(:, 2);
dp = data6(:, 3);
ud = data6(:, 4);

print_step_response_plot('angle',    t, pd, p,  '', 'mamdani_5in_5out_angle_step_response.emf'   );
print_step_response_plot('current',  t, [], i,  '', 'mamdani_5in_5out_current_step_response.emf' );
print_step_response_plot('angspeed', t, [], w,  '', 'mamdani_5in_5out_angspeed_step_response.emf');
print_step_response_plot('voltage',  t, [], u,  '', 'mamdani_5in_5out_voltage_step_response.emf' );
print_step_response_plot('moment',   t, [], m,  '', 'mamdani_5in_5out_moment_step_response.emf'  );
print_step_response_plot('error',    t, [], e,  '', 'mamdani_5in_5out_error_step_response.emf'   );
print_step_response_plot('speed',    t, [], dp, '', 'mamdani_5in_5out_speed_step_response.emf'   );
print_step_response_plot('voltaged', t, [], ud, '', 'mamdani_5in_5out_voltaged_step_response.emf');

yd = reshape(evalfis(fis, x), length(x1), length(x2))';
print_surface_plot(x1, x2, yd, '', 'mamdani_5in_5out_surface');
print_membership_functions_plot('error',   x1, 5, 'trimf', '', 'error_5in.emf'  );
print_membership_functions_plot('speed',   x2, 5, 'trimf', '', 'speed_5in.emf'  );
print_membership_functions_plot('voltage', y,  5, 'trimf', '', 'voltage_5in.emf');
