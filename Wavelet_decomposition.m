clear
clc
close all

%loading of wav file
[truesignal,fs] =audioread('preamble10.wav');
N = length(truesignal);
fprintf('OK\n');
%the scalar SNR specifies the signal-to-noise ratio per sample, in dB
sn = -5;
%add white Gaussian noise to a signal
truesignalN = awgn(truesignal,sn,'measured');
SNR = snr(truesignalN,truesignalN-truesignal);
fprintf('OK\n');

% DWT :wavelet decomposition   %
%Decomposition. Choose a wavelet.
%decomposition of the signal s at level N.
%level = 3(default);

fprintf('\nInput Level number')
level=input('\n level = ');

fprintf('\n   Input the number of specific wavelet: (1) db13, (2) db40, (3) sym13 or (4) sym21');
 wname = input('\n   wname = ');
%wname = 1;
if wname == 1
    wt = 'db13';
elseif wname == 2
    wt = 'db40';
elseif wname == 3
    wt = 'sym13';
elseif wname == 4
    wt = 'sym21';
end



%computes four filters
[Lo_D,Hi_D,Lo_R,Hi_R] = wfilters(wt);        
[C,L] = wavedec(truesignalN,level,Lo_D,Hi_D);
%Approximation Co-efficients 
cA_final = appcoef(C,L,wt,level);
%extract the levels 3, 2, and 1 detail coefficients from C
k=level;
rows=level+1;
figure;
while k>0
    mat=detcoef(C,L,[k]);
    subplot(rows,1,k)
    plot(mat);
    str = sprintf('Level %d Detail Coefficients', k);
    title(str);
    k=k-1;

end

subplot(rows,1,rows);
plot(cA_final);
title('Approximation Coefficients');

rows=level+1;
k=1;
figure;
subplot(rows,1,1);
plot(truesignalN);
title('Noisy Signal ');
while k<=level
    mat= wrcoef('d',C,L,Lo_R,Hi_R,k);
    subplot(rows,2,2+k);
    plot(mat);
    str = sprintf('Detail %d', k);
    title(str);
    k=k+1;

end
subplot(rows,2,2+k);
A=wrcoef('a',C,L,Lo_R,Hi_R,level);
plot(A);
str = sprintf('Approximation  A%d', level);
title(str);


    

% %----------------playing audio----------------------------------------- 

fprintf('\n   Play the Original Sound:');
player= audioplayer(truesignal,fs);
playblocking(player);
pause(1);
fprintf(' OK');
fprintf('\n play  noisy signal :');
noisysignal= audioplayer(truesignalN,fs);
playblocking(noisysignal);
fprintf(' OK');


