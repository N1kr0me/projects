clc;
clear;
M=0.5;
m=0.5;
b=0.1;
l=.3;
I=.006;
g=9.8;
d=I*(M+m)+M*m*l^2;
disp('state space model of the system is:')
A=[0 1 0 0;m*g*l(M+m)/d 0 0 m*l*b/d;0 0 0 1;-g*m^2*l^2/d 0 0 -b*(I+m*l^2)/d];
B=[0;-m*l/d;0;(I+m*l^2)/d];
C=[0 0 1 0;1 0 0 0];
D=[0;0];
system=ss(A,B,C,D)
disp('The transfer function of the system is:')
inputs = {'u'};
outputs = {'x'; 'theta'};
G=tf(system)
set(G,'InputName',inputs)
set(G,'OutputName',outputs)

inputs = {'u'};
outputs = {'x'; 'theta'};
set(G,'InputName',inputs)
set(G,'OutputName',outputs)
figure(1);clf;subplot(221)
t=0:0.01:1;
impulse(G,t);
grid;
title('Open-Loop Impulse Response of the system')

subplot(222)
t = 0:0.05:10;
u = ones(size(t));
[y,t] = lsim(G,u,t);
plot(t,y)
title('Open-Loop Step Response of the system')
axis([0 2 -50 50])
legend('x','theta')
grid;
disp('Poles of the system are:')
Poles=eig(A)
subplot(2,2,3:4)
pzmap(system);
title('Pole-zero mapping of inverted pendulum')
disp('checking controllability:')
CO=ctrb(system);
Rank_CO=rank(CO)
unco=length(A)-rank(CO)
if(unco==0)
 disp('system is controllable!')
else
 disp(['number of uncontrollable states are:',unco])
end;
disp('Checking observability:')
OB=obsv(system);
Rank_OB=rank(OB)
unobsv=length(A)-rank(OB)
if(unobsv==0)
 disp('system is observable!')
else
 disp(['number of unobservable states are:',unobsv])
end;

disp('desirable poles and the respective gain vectors:')

desirable_1=[-2.433 -1.622 -0.811+1.584j -0.811-1.584j]
K1=place(A,B,desirable_1)
Ac1 = A-B*K1;
system_c1 = ss(Ac1,B,C,D);
t = 0:0.01:10;
r =0.2*ones(size(t));
figure(2);clf;subplot(311)
[y,t,x]=lsim(system_c1,r,t);
[AX,H1,H2] = plotyy(t,y(:,1),t,y(:,2),'plot');
set(get(AX(1),'Ylabel'),'String','cart position (m)')
set(get(AX(2),'Ylabel'),'String','pend-angle(rad)')
title('Step Response using pole placement-1st test')
grid

desirable_2=[-8.11 -4.055 -0.811+1.584j -0.811-1.584j]
K2=place(A,B,desirable_2)
Ac2 = A-B*K2;
system_c2 = ss(Ac2,B,C,D);
t = 0:0.01:10;
r =0.2*ones(size(t));
subplot(312)
[y,t,x]=lsim(system_c2,r,t);
[AX,H1,H2] = plotyy(t,y(:,1),t,y(:,2),'plot');
set(get(AX(1),'Ylabel'),'String','cart position (m)')
set(get(AX(2),'Ylabel'),'String','pend-angle(rad)')
title('Step Response using pole placement-2nd test')
grid

desirable_3=[-11.354 -9.732 -0.811+1.584j -0.811-1.584j]
K3=place(A,B,desirable_3)
Ac3 = A-B*K3;
system_c3 = ss(Ac3,B,C,D);
t = 0:0.01:10;
r =0.2*ones(size(t));
subplot(313)
[y,t,x]=lsim(system_c3,r,t);
[AX,H1,H2] = plotyy(t,y(:,1),t,y(:,2),'plot');
set(get(AX(1),'Ylabel'),'String','cart position (m)')
set(get(AX(2),'Ylabel'),'String','pend-angle(rad)')
title('Step Response using pole placement-3rd test')
grid

% LQR Method
disp('The weight matrices Q and R and the vector K:')
Q = C'*C;
Q(1,1) = 80; 
Q(3,3) = 400 
R = 1
K = lqr(A,B,Q,R) 
Ac = A-B*K; 
system_c = ss(Ac,B,C,D); 
t = 0:0.01:10;
r =0.2*ones(size(t));
figure(3);clf
[y,t,x]=lsim(system_c,r,t);
[AX,H1,H2] = plotyy(t,y(:,1),t,y(:,2),'plot');
set(get(AX(1),'Ylabel'),'String','cart position (m)')
set(get(AX(2),'Ylabel'),'String','pendulum angle (radians)')
title('Step Response using LQR')
grid

% [LQR + steady state error controller]
Cn = [0 0 1 0];
Nbar=-inv(Cn*((A-B*K)\B)); 
sys_lqr_et = ss(Ac,B*Nbar,C,D);
t = 0:0.01:10;
r =0.2*ones(size(t));
figure(4);clf
[y,t,x]=lsim(sys_lqr_et,r,t);
[AX,H1,H2] = plotyy(t,y(:,1),t,y(:,2),'plot');
set(get(AX(1),'Ylabel'),'String','cart position (m)')
set(get(AX(2),'Ylabel'),'String','pendulum angle (radians)')
title('Step Response using LQR and steady state error controller')
grid

%Designing state observer (state estimator)
ob = obsv(system_c); 
observability = rank(ob)
contr_poles = eig(Ac) 
obsr_poles = [-30 -31 -32 -33] 
L = place(A',C',obsr_poles)' 

%response of the system with controller + observer = compensator
Aco = [(A-B*K) (B*K);zeros(size(A)) (A-L*C)];
Bco = [B;zeros(size(B))];
Cco = [C zeros(size(C))];
Dco = [0;0];
sys_co_ob = ss(Aco,Bco,Cco,Dco);
t = 0:0.01:10;
r = 0.2*ones(size(t));
figure(5);clf
[y,t,x]=lsim(sys_co_ob,r,t);
[AX,H1,H2] = plotyy(t,y(:,1),t,y(:,2),'plot');
set(get(AX(1),'Ylabel'),'String','cart position (m)')
set(get(AX(2),'Ylabel'),'String','pendulum angle (radians)')
title('Step Response using compensator (controller + observer)')
grid

% the new system with Compensator + no steady state error tracker
Acl = [(A-B*K) (B*K);zeros(size(A)) (A-L*C)];
Bcl = [B;zeros(size(B))];
Ccl = [C zeros(size(C))];
Dcl = [0;0];
Ccln=[Cn zeros(size(Cn))];
Nbar=-inv(Ccln*(Acl\Bcl))
Bclt = [B*Nbar;zeros(size(B))];
sys_cm_et = ss(Acl,Bclt,Ccl,Dcl);
t = 0:0.01:10;
r = 0.2*ones(size(t));
figure(6);clf
[y,t,x]=lsim(sys_cm_et,r,t);
[AX,H1,H2] = plotyy(t,y(:,1),t,y(:,2),'plot');
set(get(AX(1),'Ylabel'),'String','cart position (m)')
set(get(AX(2),'Ylabel'),'String','pendulum angle (radians)')
title('Step Response using compensator with steady state error controller')
grid
