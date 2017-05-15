function e = q_pid(params)

set_param('model/PID/Kp', 'Gain', num2str(params(1)));
set_param('model/PID/Ki', 'Gain', num2str(params(2)));
set_param('model/PID/Kd', 'Gain', num2str(params(3)));
% set_param('model/Kt', 'Gain', num2str(params(4)));
sim('model');

e = sum((e.signals.values).^2);

end