close all; clear all;

load('parametry.mat')
load('../pomiary/skok_jednostkowy')

NUM = [K];
DEN = [ T 1 ];
SYS = tf(NUM, DEN);

[y, t] = lsim(SYS, obiekt.signals(1).values, obiekt.time, [0 0]);

figure; hold on; grid on;
plot(obiekt.time, obiekt.signals(3).values)
plot(t, y, 'r')