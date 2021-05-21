clear; clc; close all

Text_filename  = 'SampleText.txt';
cover_img_name = 'Lena.png';

I=imread(cover_img_name);
figure(1); imshow(I);

algo   = ["PVD","kLSB",  "kLSB", "kLSB", "kLSB", "kLSB"];
xticks = ["PVD","LSB_1","LSB_2","LSB_3","LSB_4","LSB_5"];

for i = 1:length(algo)
%% Quantum Key Distribution

[ak,bk] = QKD(100,0);

Algorithm = algo(i);

%% Transmitter side

encrypt(Text_filename,'cipher_tx.LZ78',ak);
txt_stego_im( Algorithm, i-1, cover_img_name, 'cipher_tx.LZ78', 'stego.png');

%% Receiver side

im_stego_txt( Algorithm, i-1, 'stego.png', 'cipher_rx.LZ78');
decrypt('cipher_rx.LZ78', 'Rx.txt', bk);

%% checking

fid = fopen(Text_filename,'r');
x = char(fread(fid)');
fclose(fid);

fid = fopen('Rx.txt','r');
y = char(fread(fid)');
fclose(fid);

disp(sum(x(1:length(y))==y))

%%

S=imread("stego.png");

d = abs(I-S);

figure(2); subplot(2,3,i); imshow( histeq(d),[]); title(xticks(i));
figure(3); subplot(2,3,i); imshow(S); title(xticks(i));

MSE(i) = sum(mse(I,S),3)/3;

PSNR(i) = psnr(S,I);

Cap(i) = length(y);

bpp(i) = round(8*Cap(i)/numel(I),3);

end

%% Plotting

figure; bar(MSE); grid on
text(1:length(algo),MSE,string(MSE),'HorizontalAlignment','center','VerticalAlignment','bottom')
title('MSE')
set(gca,'xticklabel',xticks)

figure; bar(PSNR); grid on
text(1:length(algo),PSNR, string(PSNR),'HorizontalAlignment','center','VerticalAlignment','bottom')
title('PSNR')
set(gca,'xticklabel',xticks)

figure; bar(Cap); grid on
text(1:length(algo),Cap,string(Cap),'HorizontalAlignment','center','VerticalAlignment','bottom')
title('Capacity (no.of characters embedded)')
set(gca,'xticklabel',xticks)

figure; bar(bpp); grid on
text(1:length(algo),bpp,string(bpp),'HorizontalAlignment','center','VerticalAlignment','bottom')
title('Bits per pixel')
set(gca,'xticklabel',xticks)
