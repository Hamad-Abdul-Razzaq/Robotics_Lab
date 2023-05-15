function xdot = DynOde(t,y)
global tau;
%% init constants;
m1 = 1;
m2 = 1;
a1 = 1;
a2 = 1;
g = 9.8;
T1 = tau(int64(t/0.01)+1);
T2 = tau(int64(t/0.01)+1);

x1dot  = y(2);
x1ddot = (T1*a2 - 2*a2 - 2*a1*cos(y(3)) - a1*a2*g*m1*cos(y(1)) - a1*a2*g*m2*cos(y(1)) + a1*a2^2*m2*sin(y(3))*y(2)^2 + a1*a2^2*m2*sin(y(3))*y(4)^2 + a1*a2*g*m2*cos(y(3))*cos(y(1) + y(3)) + a1^2*a2*m2*cos(y(3))*sin(y(3))*y(2)^2 + 2*a1*a2^2*m2*sin(y(3))*y(2)*y(4))/(a2*(a1^2*m1 + a1^2*m2 - a1^2*m2*cos(y(3))^2));
x2dot = y(4) ;
x2ddot = (T1*a2 - 2*a2 - 2*a1*cos(y(3)) - a1*a2*g*m1*cos(y(1)) - a1*a2*g*m2*cos(y(1)) + a1*a2^2*m2*sin(y(3))*y(2)^2 + a1*a2^2*m2*sin(y(3))*y(4)^2 + a1*a2*g*m2*cos(y(3))*cos(y(1) + y(3)) + a1^2*a2*m2*cos(y(3))*sin(y(3))*y(2)^2 + 2*a1*a2^2*m2*sin(y(3))*y(2)*y(4))/(a2*(a1^2*m1 + a1^2*m2 - a1^2*m2*cos(y(3))^2));

xdot = [x1dot;x1ddot;x2dot;x2ddot];
end
