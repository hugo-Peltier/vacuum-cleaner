Ts = 0.05;
Tsim = 600;

roomL = 20;
b = 0.30;
r = 0.05;

v_max = 0.30;
v_line = 0.25;
v_wall = 0.18;

d_ref = 0.30;
d_warn = 0.50;
d_stop = 0.25;

x0 = 0; y0 = 0; theta0 = 0;
X0 = [x0 y0 theta0];

obs.center = [3,3];
obs.radius = 0.25;

ctrl.k_theta = 2.0;
ctrl.k_y = 1.2;
ctrl.L = 0.5;
ctrl.kd = 1.5;
ctrl.kd_dot = 0.3;

grid.res = 0.20;
grid.N = round(roomL/grid.res);
grid.clean_radius = 0.20;
grid.map = zeros(grid.N);
grid.clean = false(grid.N);
grid.xmin = -roomL/2; grid.ymin = -roomL/2;

assignin('base','Ts',Ts);
assignin('base','Tsim',Tsim);
assignin('base','roomL',roomL);
assignin('base','b',b);
assignin('base','r',r);
assignin('base','v_max',v_max);
assignin('base','v_line',v_line);
assignin('base','v_wall',v_wall);
assignin('base','d_ref',d_ref);
assignin('base','d_warn',d_warn);
assignin('base','d_stop',d_stop);
assignin('base','X0',X0);
assignin('base','obs',obs);
assignin('base','ctrl',ctrl);
assignin('base','grid',grid);
