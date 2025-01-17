%Designing a Gantry Crane Controller to control the position of the trolley
%and angle of the payload


%System Parameters
g = 9.81;
m = 0.3;
M = 0.1;
l = 1.5;
%System model(linearized)
%%Input = f and output = x
A = [0 1 0 0;
     0 0 (m*g)/M 0;
     0 0 0 1;
     0 0 (((M+m)*-g)/(M*l)) 0];

B = [0;
     1/M;
     0;
     1/(-M*l)];

C = [1 0 0 0;
     0 0 1 0];

D = 0;
x0 = [0 0 0 0]; %Initial State
system = ss(A, B, C, D);
transfer_function = tf(system);
%The system is both Observable and Controllable
%%Start designing using full-state feedback and then use a full-state
%%estimator
%%%Feedback design for settling time of 4s and peak overshoot of 5%

%State feedback design

desired_poles = [-1 + 1i*1.05, -1 - 1i*1.05, -10, -11];
%Gain matrix K
K = place(A, B, desired_poles);
%Closed loop system
A_cl = A - B*K;
system_cl = ss(A_cl, B, C, D);
cl_transfer_function = tf(system_cl);
position_tf = cl_transfer_function(1);

%Very high steady-state error
%%Compensator design
compensator = tf([3.15 3.6], [1 0]);

%Compensated design
compensated_system_tf = feedback(compensator*cl_transfer_function, [1 1]);