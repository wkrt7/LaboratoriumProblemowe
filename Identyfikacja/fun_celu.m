function err = fun_celu( x, t, u, signal )
martwa_strefa = 0.08
K = x(1); T = x(2);
obiekt_sym = tf(K, [T 1]);

for i=1:length(u)
    if (abs(u(i)) <= martwa_strefa)
        u(i) = 0;
    else
        u(i) = u(i) - martwa_strefa*sign(u(i));
    end
end

[y t] = lsim(obiekt_sym, u, t, 0);
diff = signal - y;
err = sum((diff).^2);

end

