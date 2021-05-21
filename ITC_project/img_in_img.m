clear; clc

%% without hilbert fractal

C = imread('Lena.png');
H = imread('mandril.png');

c = C(1:size(H,1),1:size(H,2),:);
s = bitshift( bitshift(c,-4),4) + bitshift(H,-4);

S = C;
S(1:size(H,1),1:size(H,2),:) = s;

figure;
subplot(231);imshow(S)
subplot(232); imshow( bitshift(S,4));
subplot(233);imshow(histeq(C-S),[])

subplot(234);imshow(entropyfilt(S(:,:,1)),[])
subplot(235);imshow(entropyfilt(S(:,:,2)),[])
subplot(236);imshow(entropyfilt(S(:,:,3)),[])


%% with hilbert fractal

in = dec2bin( bitshift(H,-4) ,4)';
in = in(:)';

[PX,PY] = hilbert_fractal_generating(8);

Sh = klsb(4,"encoding",C,in,PX,PY);
figure;
subplot(231);imshow(Sh)
subplot(232); imshow( bitshift(Sh,4));
subplot(233);imshow(histeq(C-Sh),[])

subplot(234);imshow(entropyfilt(Sh(:,:,1)),[])
subplot(235);imshow(entropyfilt(Sh(:,:,2)),[])
subplot(236);imshow(entropyfilt(Sh(:,:,3)),[])

