% This is a matlab/octave script to solve 1D diffusion equation for its implicit solution by using 
% Pseudo-transient method. 
% It differs from Diff1D_implicit by adding the dampening of the dTdtau to 
% speed up the convergence! Only two line code is added but it become much faster! 7000 iteration Vs 700 iteration
% _2nd mean it is 2nd order convergence!

clear;clf

Lx  = 10;       %model length. used as the length scale
D   = 100;      %diffusion coefficient
nx  = 50*10;    %nx cell
dx  = Lx/nx;    %cell width
Imax= 100*nx;   %maximum iteration number
tsc = Lx*Lx/D;  %diffusion timescale
%Initiation 
t0 = Lx*Lx/D/160; %t0 for the analytical solution!
x  = linspace(0,Lx,nx+1);     % x coordinates for the grid/node 
xc = (x(1:end-1)+x(2:end))/2; % x coordinates at the center of the cell.
% staggered grid: velocity field is at x, while scalar field T is at xc. 
T  = zeros(1,nx);
a  = 0.5*Lx;
T0 = exp(-(xc-a).^2/4/D/t0); 
% Notice that boundary condition should depend on t in order to have the simple
%analytical solution. Here we choose t0 to make the boundary temperature close to 0.
%t00=s
Told = T0;
T    = T0;
Vx   = zeros(1,nx-1);  %Vx at the boundary is not included here! Otherwise it should be nx+1
f    = sin(xc); f(:)=0;% f=0 to compare with the analytical solution that has no heat source.
%Boundary condition
ttol = 1.6*t0 # As this script is slow. Lets compute a small ttol! 
Tana = sqrt(t0/(t0+ttol)).*exp(-(xc-a).^2/(4*D*(t0+ttol)));
T(1) = Tana(1);T(end)=Tana(end);
dTdtau1 = zeros(1,nx-2); % pseudo time derivative!
dTdtau2 = zeros(1,nx-2); % pseudo time derivative with dampening
cnt  = 200;
epsi = 1e-8; % accuracy for the convergence
ndim = 1;
dtc  = dx*dx/2/D/ndim;
CFL  = 0.9;
dtau = CFL*dtc; % pseudo timestep!
dt   = 500*dtc     % physical timestep, could be larger than dtau and be stable as it is implicit solution. 
itertol = 0;
time    = 0; 

residdT  = 1e5;
it       = 0;
damp     = 1-6*pi/nx;% 0.93 %0.991 %  WHL: does not work quite well with nx>=500.
kw       = 1;
A        = CFL*pi*pi*kw*kw/nx/nx/2;
damp     = 1-2*sqrt(dtau/dt+A); # A more delicated dampening parameter! work with both low and high nx (50-2000)
%WHL: This is the optimized dampening parameter I derived at 2Sep2024. It is faster than 1-6*pi/nx.
% The time ratio is dominant over A as A is very small! So one can simply use: 1-2*sqrt(dtau/dt)
% Try low nx to test the effect of A, +A converge much faster than -A when nx=50. So +A is correct!
dampening= 1;
%while (time<ttol*0.99 &&it<10000)
#while it<100
while time<0.99*ttol
%for it=1:100
       iter     = 0; 
       residdT  = 2*epsi;
%for iter=1:Imax
   while residdT>epsi && iter<Imax
          q        = -D*diff(T)/dx;    % dimension:nx-1
          dTdtau1   = -(T(2:nx-1)-Told(2:nx-1))/dt-diff(q)/dx; %dimension:nx-2. residual from Lesson2:Eq.2)
      if dampening == 0  %****dTdtau is used. simple and slow!
          T(2:nx-1) = T(2:nx-1) + dtau*dTdtau1;     %nx-2. Update T by pseudo time marching.  Lesson2:Eq.3)
      else               %****dTdtau2 contains the currect residual and the previous residual, which greatly speed up the convergence!
                         %The formulation can be derive with 2nd pseudo transient time derivative dT2dtau !
          dTdtau2    = dTdtau1 + damp*dTdtau2;  
          T(2:nx-1) = T(2:nx-1) + dtau*dTdtau2; % dTdtau is used 
      end
       residdT  = max(abs(dTdtau1)); %
       iter     = iter+1;
       if mod(iter,cnt)==0
          plot(xc,T,'r',xc,T0,'k');drawnow
         fprintf('Iteration %d, residdT=%7.3e\n',iter,residdT); 
       end   
    end
    it   = it+1;
    time = time+dt;  % update the physical time!
    Told = T;                % update the Told after one physical timestep.
    itertol = itertol+iter;
    fprintf('Step %d converged,residdT=%7.3e\n',it,residdT); 
end
%Tana=1/sqrt(4*(ttol+1/4)).*exp(-(xc-a).^2/(4*(ttol+1/4)));
% initial condition: T(x,t0)=exp(-x*x/(4*D*t0))  %Let:t0=0.1;
%analytical solution:T(x,t)=sqrt(t0/t)exp(-x*x/(4*D*t));
%Tana = sqrt(t0/(ttol)).*exp(-(xc-a).^2/(4*D*ttol));
Tana = sqrt(t0/(t0+time)).*exp(-(xc-a).^2/(4*D*(t0+time)));
figure();plot(xc,T,'b',xc,Tana,'r',xc,T0,'k')

fprintf('Total %d step are calculated.\n The physical time is =%3.1f, totel iteration is %d (%3.1f *nx), with dampeng=%d\n',it,time,itertol,itertol/nx,dampening); 

%Exercise1: 1. change t0 and see if the numerical solution still matches the analytical solution
%            2. change nx,dtau and see if it still produce reasonable results.
%            3. After finding out the numerical solution is correct, remove the analytical solution and use any initial boundary condition.
%            4. rewrite the code with another language, for example, julia and python. Notice matlab and julia counter from 1, while python counter from 0. 


% exercise for dampening.
% write an code to find out the optimized dampening parameters (damp) by testing damp from 0 to 1.
