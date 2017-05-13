clear all; close all;

%% Martwa strefa
% ramp_up = load('../pomiary/ramp1_new.mat');
% ramp_down = load('../pomiary/ramp2_new.mat')
% figure(1); hold on; grid on;
% axis([-1.3 1.3 -150 150 ])
% plot(ramp_up.obiekt.signals(1).values, ramp_up.obiekt.signals(3).values)
% plot(ramp_down.obiekt.signals(1).values, ramp_down.obiekt.signals(3).values, 'r')
% legend('Ramp-up', 'Ramp-down')
% xlabel('sterowanie [V]'); ylabel('prêdkoœæ [rad/s]');
% print('obrazy/martwa_strefa.png', '-dpng', '-r600')
% %martwa_plus = [0 0.08]
% %martwa_minus = [-0.08 0.03]
% 
% %Odczytane na oko - do weryfikacji
martwa_strefa = 0.08;
% 
% 
%% OFFSET
% Wersja ze sterowaniem zerowym
load('../pomiary/zero.mat')
offset = mean(obiekt.signals(3).values(100:end-100))

%% Identyfikacja
dir_data = '../pomiary/skok/';
mat_files = dir(strcat(dir_data, '*.mat'));
options = optimset('MaxFunEvals',10000);

for i = 1:length(mat_files)
    load(strcat(dir_data,num2str(mat_files(i).name))); 
    [opt err] = fminsearch(@(x) fun_celu(x, obiekt.time, obiekt.signals(1).values, obiekt.signals(3).values-offset), [1 1], options);
    K_temp(i) = opt(1);
    T_temp(i) = opt(2);
    
end

% load('../pomiary/sinus/sinus001.mat')
%load('../pomiary/skok/skok09.mat')
load('../pomiary/skok_jednostkowy')
K = mean(K_temp)
T = mean(T_temp)

obiekt_sym = tf(K, [T 1]);
 
u = obiekt.signals(1).values;

for i=1:length(u)
    if (abs(u(i)) <= martwa_strefa)
        u(i) = 0;
    else
        u(i) = u(i) - martwa_strefa*sign(u(i));
    end
end

[y t] = lsim(obiekt_sym, u, obiekt.time, 0);

figure(2)
hold on; grid on;
plot(obiekt.time, obiekt.signals(3).values-offset)
plot(t, y, 'r')
% 
% save('parametry', 'martwa_strefa', 'offset', 'K', 'T');