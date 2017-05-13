clear all; close all;
load('../identyfikacja/parametry.mat')
sim('model.slx')
[opt err] = fminsearch(@(params) q_pid(params), [0 0 0 0]);
Kp = opt(1)
Ki = opt(2)
Kd = opt(3)
Kt = opt(4)
set_param('model/PID/Kp', 'Gain', num2str(Kp));
set_param('model/PID/Ki', 'Gain', num2str(Ki));
set_param('model/PID/Kd', 'Gain', num2str(Kd));
set_param('model/Kt', 'Gain', num2str(Kt));
sim('model');

figure; hold on; grid on;
plot(u.time, u.signals.values);
plot(y.time, y.signals.values, 'r');
xlabel('czas [s]'); ylabel('prêdkoœæ [rad/s]');
leg = legend('wartoœæ zadana', 'odpowiedŸ modelu');