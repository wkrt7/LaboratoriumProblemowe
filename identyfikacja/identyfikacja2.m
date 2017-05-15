clear all; close all;

%% Martwa strefa
ramp_up = load('../pomiary/ramp1_new.mat');
ramp_down = load('../pomiary/ramp2_new.mat');
figure(1); hold on; grid on;
axis([-1.3 1.3 -150 150 ])
plot(ramp_up.obiekt.signals(1).values, ramp_up.obiekt.signals(3).values)
plot(ramp_down.obiekt.signals(1).values, ramp_down.obiekt.signals(3).values, 'r')
legend('Ramp-up', 'Ramp-down')
xlabel('sterowanie [V]'); ylabel('prêdkoœæ [rad/s]');
print('../obrazy/martwa_strefa.png', '-dpng', '-r600')
%martwa_plus = [0 0.08]
%martwa_minus = [-0.08 0.03]

%Odczytane na oko - do weryfikacji
martwa_strefa = 0.08;
% 
% 
%% OFFSET
% Wersja ze sterowaniem zerowym
load('../pomiary/zero.mat')
offset = mean(obiekt.signals(3).values(100:end-100));

%% Identyfikacja
dir_data = '../pomiary/skok/plus/';
mat_files = dir(strcat(dir_data, '*.mat'));
options = optimset('MaxFunEvals',10000);

for i = 1:length(mat_files)
    load(strcat(dir_data,num2str(mat_files(i).name))); 
    [opt err] = fminsearch(@(x) fun_celu(x, obiekt.time, obiekt.signals(1).values, obiekt.signals(3).values-offset), [1 1], options);
    K_temp_plus(i) = opt(1);
    T_temp_plus(i) = opt(2);
end

dir_data = '../pomiary/skok/minus/';
mat_files = dir(strcat(dir_data, '*.mat'));
options = optimset('MaxFunEvals',10000);

for i = 1:length(mat_files)
    load(strcat(dir_data,num2str(mat_files(i).name))); 
    [opt err] = fminsearch(@(x) fun_celu(x, obiekt.time, obiekt.signals(1).values, obiekt.signals(3).values-offset), [1 1], options);
    K_temp_minus(i) = opt(1);
    T_temp_minus(i) = opt(2);
end

load('../pomiary/skok/minus/skokminus09.mat')

K_plus = mean(K_temp_plus)
T_plus = mean(T_temp_plus)
K_minus = mean(K_temp_minus)
T_minus = mean(T_temp_minus)

K = (K_plus + K_minus)/2
T = (T_plus + T_minus)/2

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
legend('OdpowiedŸ obiektu', 'OdpowiedŸ modelu', 'Location', 'northwest');
xlabel('czas [s]'); ylabel('prêdkoœæ [rad/s]');
axis([0 100 -150 150])

save('parametry_plus', 'martwa_strefa', 'offset', 'K_plus', 'T_plus');
save('parametry_minus', 'martwa_strefa', 'offset', 'K_minus', 'T_minus');
save('parametry2',  'martwa_strefa', 'offset', 'K', 'T');