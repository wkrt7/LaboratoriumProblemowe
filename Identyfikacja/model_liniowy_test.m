close all; clear all;

load('parametry.mat')
load('../pomiary/skok_jednostkowy.mat')


NUM = [K];
DEN = [ T 1 ];
SYS = tf(NUM, DEN);

u = obiekt.signals(1).values;

for i=1:length(u)
    if (abs(u(i)) <= martwa_strefa)
        u(i) = 0;
    else
        u(i) = u(i) - martwa_strefa*sign(u(i));
    end
end

[y, t] = lsim(SYS,u , obiekt.time, [0 0]);

figure; hold on; grid on;
plot(obiekt.time, obiekt.signals(3).values-offset)
plot(t, y, 'r')

diff2 = y-(obiekt.signals(3).values-offset);
err2 = sum(diff2.^2)