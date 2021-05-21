clear; clc; close all

%% Quantum Key Distribution

[ak,bk] = QKD(100,0);

Text_filename = 'plain.txt';
Algorithm = 'kLSB';

k = 0;
if string(Algorithm) == "kLSB"
    %k = input("Enter k in kLSB : ");
    k=4;
end

%% Transmitter side

LZ78_compression(Text_filename,'comp_tx.LZ78');
encrypt('comp_tx.LZ78','cipher_comp_tx.LZ78',ak);
txt_stego_im( Algorithm, k, 'Lena.png', 'cipher_comp_tx.LZ78', 'stego.png');

%% Receiver side


im_stego_txt( Algorithm, k, 'stego.png', 'cipher_comp_rx.LZ78');
decrypt('cipher_comp_rx.LZ78', 'comp_rx.LZ78', bk);
LZ78_decompression_v2('comp_rx.LZ78', 'Rx.txt');

%% checking

fid = fopen(Text_filename,'r');
x = char(fread(fid)');
fclose(fid);

fid = fopen('Rx.txt','r');
y = char(fread(fid)');
fclose(fid);

disp(sum(x(1:length(y))==y))
