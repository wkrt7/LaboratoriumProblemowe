close all; clear all;

%load('ramp1_new');
load('charakterystyka_statyczna.mat')

for i = 1:42
   control(i) = obiekt.signals(1).values(500*i);
   velocity(i) = mean(obiekt.signals(3).values(500*i-10:500*i));
end

plot(control, velocity, '.', 'markersize', 15);

hold on
grid on

velocity(11) 
velocity(32)
offset = mean([velocity(11) velocity(32)])
