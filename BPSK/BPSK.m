clear all;                                  
close all;                                  
tic
num=1000000;                                      
EbNodB=0:0.5:10;                              
EbNo=10.^(EbNodB/10);
p = 0;
fc = 1000;
fs = 1;
Ts = 1/fs;
Tc = 1/fc;
t = 0:Tc:2*Ts;
car = cos(2*pi*fc*t);
for n=1:length(EbNodB); 
    if n <= 8
        num = 10000;
    elseif n <=16
        num = 100000;
    else
        num = 1000000;
    end
    s=2*round(rand(1,num))-1;
    s=s*sqrt(EbNo(n));
    error = 0; 
   
    
    for k =1 : num
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        data = car.*s(k);           %modulate
        for x =1: 2000              %demodulate
        data2(x)= data(x)./car(x);
        end
        p = sum(data2)/2000; 
        d_s(k) = p;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        r(k)=d_s(k)+sqrt(1/2)*randn(1,1);
        pause(0.001);
    end
    s_estimate=sign(r)*sqrt(EbNo(n));
    BER(n)=(num-sum(s==s_estimate))/num;             
end

semilogy(EbNodB, BER,'-');                 
xlabel('Eb/No(dB)')                             
ylabel('BER')                               
grid on;
hold on;
BER_th=(1/2)*erfc(sqrt(EbNo)); 
semilogy(EbNodB,BER_th);
title('Bit Error Rate for Binary Phase Shift Keying');
legend('simulation','theorytical')
timeElapsed = toc