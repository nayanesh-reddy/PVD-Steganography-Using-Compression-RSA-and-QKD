clear; clc; close all

%% Quantum Key Distribution

[ak,bk] = QKD(100,0);

Text_filename = 'SampleText.txt';
Algorithm = 'kLSB';

k = 0;
if string(Algorithm) == "kLSB"
    k = input("Enter k in kLSB : ");
    %k=2;
end

%% Transmitter side

encrypt(Text_filename,'cipher_tx.LZ78',ak);
txt_stego_im( Algorithm, k, 'Lena.png', 'cipher_tx.LZ78', 'stego.png');

%% Receiver side

im_stego_txt( Algorithm, k, 'stego.png', 'cipher_rx.LZ78');
decrypt('cipher_rx.LZ78', 'Rx.txt', bk);

%% checking

fid = fopen(Text_filename,'r');
x = char(fread(fid)');
fclose(fid);

fid = fopen('Rx.txt','r');
y = char(fread(fid)');
fclose(fid);

disp(sum(x(1:length(y))==y))

%% plotting

I=imread('Lena.png');
S=imread("stego.png");

d = abs(I-S);
ds = (I-S).^2;

figure;imshow(d(:,:,1),[])
figure;imshow(d(:,:,2),[])
figure;imshow(d(:,:,3),[])

disp( sum(ds(:))/numel(I) )

disp(psnr(S,I))

figure; imshowpair(I,S,'montage')
