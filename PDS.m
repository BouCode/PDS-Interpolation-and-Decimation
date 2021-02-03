x = 0:0.01:10;
y = sin (x);
interv = 32;

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
plot (x, y);
figure (2);
plot (x, y_transf);