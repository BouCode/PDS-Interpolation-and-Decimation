x = 0:0.01:10;
y = 5 *sin (x);

[y, Fs] = audioread ('sound2.wav');
fc = 2000;
FC = fc/(Fs/2);
M = 15;
N = length (y);
fp= Fs* [0:N-1]/N;
T = 1/Fs;
x = [0:N-1]'*T;

interv = 16;
max_y = max(y);
min_y = min (y);
amp_total = abs(min_y) + abs(max_y);
amp_interv = amp_total/interv;

interv_range_min = [];

for i = 1:interv+1
    interv_range_min = [ interv_range_min, min_y + amp_interv * (i - 1)];
endfor


y_transf = [];


for i = 1:length(y)
  for j = 1:interv+1
    if (y(i) > interv_range_min (j) - amp_interv/2 && y(i) <= interv_range_min (j) + amp_interv/2)
      y_append = interv_range_min (j);
      y_transf = [ y_transf, y_append];
    endif
  endfor
endfor

y_transf;
figure (1); 
title ('Analog signal')
plot (x, y);
figure (2);
title ('Digital signal')
plot (x, y_transf);

#pkg load signal
#Inserting n-1 zeros between every element.
n = 2;

y_upsample = upsample (y_transf, n);
fp = Fs .* linspace (0, x(N-1), length (y_upsample))/N;
x = linspace (0, x(N-1), length (y_upsample));
#fp= Fs* [0:N-1]/N;
length (fp)
length (y_upsample)
length (x)
x_upsample = x;

figure (3)
title ('Graphics sampling')
plot (x_upsample, y_upsample)

#Discrete_Time: Filter
N = length (y_upsample);

y = fft (y_upsample);
y = fftshift (y);
y = abs (y);
ny = y/max(y);

length(fp(1:(N/n)))
length (y((n-1)*N/n:end-1))
figure (4);
title ('x[n]')
plot (fp(1:(N/n)), y((n-1)*N/n:end-1));
xlabel ('Frecuencia (Hz)')
grid

b_l = fir1 (M, FC, "low");
z1 = conv (y_upsample, b_l);
xf1 = filter (b_l, 1, y_upsample);

s1 = fft (b_l, N);
s1 = fftshift (s1);
s1 = abs (s1);
ns1 = s1/max(s1);

p1 = fft (xf1, N);
p1 = fftshift (p1);
p1 = abs (p1);
np1 = p1/max(p1);

figure (5)
plot (fp (1:(N/n)), ny((n-1)*N/n:end-1))
hold on;
plot (fp (1:(N/2)), ns1(N/2:end-1), 'color', 'r');
hold off;
title ('Pasa bajo: Frecuencia');
grid on;

figure (6)
plot (fp(1:(N/n)), np1(N*(n-1)/n:end -1))
title ('Pasa bajo: Señal filtrada');
xlabel('Hz');
ylabel('Amplitud')
grid on;

figure (7)
plot (x, y_upsample);
hold on;
plot (x, z1(1:length(z1)-M));
title ('Convolucion pasa bajo')
grid

Ganancia = 2;
y_filtrado = z1 (1:length(z1)-M);
y_ganancia = Ganancia * y_filtrado;

interv = 16;
max_y = max(y_ganancia);
min_y = min (y_ganancia);
amp_total = abs(min_y) + abs(max_y);
amp_interv = amp_total/interv;

interv_range_min = [];

for i = 1:interv+1
    interv_range_min = [ interv_range_min, min_y + amp_interv * (i - 1)];
endfor


y_transf_2 = [];


for i = 1:length(y_ganancia)
  for j = 1:interv+1
    if (y_ganancia(i) > interv_range_min (j) - amp_interv/2 && y_ganancia(i) <= interv_range_min (j) + amp_interv/2)
      y_append = interv_range_min (j);
      y_transf_2 = [ y_transf_2, y_append];
    endif
  endfor
endfor

y_transf_2;
figure (8); 
title ('Analog signal')
plot (x, y_ganancia);
figure (9);
title ('Digital signal')
plot (x, y_transf_2);
