

% Capacitor that is being charged by a comperator, the output of this
% system creates a clock. The supply voltage is 5 volt, the top ceiling
% is 4 volts and the bottom ceiling is 2 volts.
clc
clear
close all
%%
Fs=48000;
c=10^-6;                    % Capacitor value
R=1000;                     % Resistance value
vcc=5;                      % Voltage value
t=0:1/Fs:0.1-1/Fs;
f=zeros(1,numel(t));        % Capacitor values
f_clock=zeros(1,numel(t));  % Clock output
sum=0;                      % helps calculate the capacitor value.
temp_time=0;
first=1;                    % Indicates the first charge up of the capacitor
key=0;                      % controls the charging/discharing of the capacitor
v_low=2;                    % bottom ceiling
v_high=4;                   % top ceiling 
for a=1:numel(t)
    if sum>v_high
      first=0;
      key=1;  
      temp_time=0;          % Reset temporary time
    elseif sum<v_low && first==0
      key=0; 
      temp_time=0;          % Reset temporary time
    end
    if key==1
        f_clock(a)=0;                             % Discharging capacitor, output voltage is zero.
        sum=v_high*exp(-temp_time/(c*R));         % The capacitor is discharged when it reaches v_high.
    else
        f_clock(a)=vcc;                           % Charging the capacitor, output voltage is vcc.
        if first==1
            sum=vcc*(1-exp(-temp_time/(c*R)));          
            % We are charging the capacitor when the starting votlage is
            % zero volt. When we insert the values for temp_time=0 we get:
            % sum=5(1-1)=0 (volt)
            %
        else
            sum=vcc-(vcc-v_low)*exp(-temp_time/(c*R)); 
            % We are charging the capacitor when we already started with a
            % voltage of v_low= 2 volt. When we insert the values for
            % temp_time =0 we get:
            % sum= 5-(3-2)*1=2 (volt)
            %
        end
    end
    f(a)=sum;
    temp_time=temp_time+1/Fs;
end
figure();
subplot(2,1,1)
plot(t,f_clock);
grid on
grid minor
subplot(2,1,2)
plot(t,f);
grid on
grid minor
disp("Done")
