clear; clc; close all

%% Alice and Bob generate same Key using Quantum Key Distribution

% If Eavesdropper is present Alice and Bob can detect eaves presence with a 
% probability of P(eave's presence) = 1 - (3/4)^n where n = no.of bits

key = QKD(50,0);
fprintf("Key  = ");
disp(key)

%% Alice side

% Encrypting the plain text using key
encrypt('plain.txt', 'cipher.txt', key);

% Hiding the cipher text in the image in Hilbert fractal pattern
txt_steno_im_h('dog.jpeg','cipher.txt','steno.png');

%% Bob side

% Extracting the hidden cipher test from steno image
im_steno_txt_h('steno.png','cipher_rx.txt');

% Decrypt the cipher text using key
decrypt('cipher_rx.txt','plain_rx.txt', key);




