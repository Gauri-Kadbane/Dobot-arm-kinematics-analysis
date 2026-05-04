%MATLAB code: R | R || R
clear all clc
syms  the1 the2 the3 t1 t2 t3 

a1 = 53.5; a2 = 150; a3 = 150;

% Forward Kinematics
H01 = [cos(t1) 0 -sin(t1) 0;...
       sin(t1) 0  cos(t1) 0;...
       0      -1   0      a1;...
       0       0   0      1];

H12 = [-sin(t2) -cos(t2) 0 90 + a2*sin(t2);...
        cos(t2) -sin(t2) 0 -a2*cos(t2);...
        0        0       1  0;...
        0        0       0  1];

H23 = [cos(t3 - t2) -sin(t3 - t2) 0 a3*sin(t3 - t2);...
       sin(t3 - t2)  cos(t3 - t2) 0 -a3*cos(t3 - t2);...
       0             0            1  0;...
       0             0            0  1];

H03 = simplify(H01*H12*H23)

t1=-2/180*pi;
t2=25/180*pi;
t3=23/180*pi;

Px = H03(1,4);
Py = H03(2,4);
Pz = H03(3,4)-53.5;

px_new= 30.0*cos(t1)*(5.0*cos(t3) + 5.0*sin(t2) + 3.0)

py_new=30.0*sin(t1)*(5.0*cos(t3) + 5.0*sin(t2) + 3.0)
 
pz_new=150.0*cos(t2) - 150.0*sin(t3)
