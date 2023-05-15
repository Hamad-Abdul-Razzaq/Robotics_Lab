syms('theta_1(t)', 'theta_2(t)', 'theta_3(t)', 'theta_4(t)', 'alpha_1', 'alpha_2', 'alpha_3', 'alpha_4', 'a_1', 'a_2', 'a_3', 'a_4', 'd_1', 'd_2', 'd_3', 'd_4');
% syms('T_01', 'T_12', 'T_23', 'T_34', 'T_04');
% a_1 = 0; a_2 = 10.8; a_3 = 10.8; a_4 = 0;

T_01 = [cos(theta_1), -sin(theta_1)*cos(alpha_1), sin(theta_1)*sin(alpha_1), a_1 * cos(theta_1);
        sin(theta_1), cos(theta_1)*cos(alpha_1), -cos(theta_1)*sin(alpha_1), a_1 * sin(theta_1);
        0, sin(alpha_1), cos(alpha_1), d_1;
        0 0 0 1];
T_12 = [cos(theta_2), -sin(theta_2)*cos(alpha_2), sin(theta_2)*sin(alpha_2), a_2 * cos(theta_2);
        sin(theta_2), cos(theta_2)*cos(alpha_2), -cos(theta_2)*sin(alpha_2), a_2 * sin(theta_2);
        0, sin(alpha_2), cos(alpha_2), d_2;
        0 0 0 1];
T_02 = T_01*T_12;
T_23 = [cos(theta_3), -sin(theta_3)*cos(alpha_3), sin(theta_3)*sin(alpha_3), a_3 * cos(theta_3);
        sin(theta_3), cos(theta_3)*cos(alpha_3), -cos(theta_3)*sin(alpha_3), a_3 * sin(theta_3);
        0, sin(alpha_3), cos(alpha_3), d_3;
        0 0 0 1];
T_03 = T_01*T_12*T_23;
T_34 = [cos(theta_4), -sin(theta_4)*cos(alpha_4), sin(theta_4)*sin(alpha_4), a_4 * cos(theta_4);
        sin(theta_4), cos(theta_4)*cos(alpha_4), -cos(theta_4)*sin(alpha_4), a_4 * sin(theta_4);
        0, sin(alpha_4), cos(alpha_4), d_4;
        0 0 0 1];
T_04 = simplify(expand(T_01*T_12*T_23*T_34));
z00 = [0;0;1];
Tt_01 = T_01(t);
Tt_02 = T_02(t);
Tt_03 = T_03(t);
Tt_04 = T_04(t);
z01 = Tt_01(1:3,3);
z02 = Tt_02(1:3,3);
z03 = Tt_03(1:3,3);
z04 = Tt_04(1:3,3);
p00 = [0; 0; 0];
p01 = Tt_01(1:3,4);
p02 = Tt_02(1:3,4);
p03 = Tt_03(1:3,4);
p04 = Tt_04(1:3,4);
J = [
    cross(z00, (p04 - p00)) cross(z00, (p04 - p01)) cross(z00, (p04 - p02)) cross(z00, (p04 - p03));
    z00 z01 z02 z03
    ];
J = simplify(expand(J))
