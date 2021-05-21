function encrypt(plain_txt_filename, cipher_txt_filename, key)

% Using XOR cipher

fid=fopen(plain_txt_filename,'r');
x=transpose(fread(fid)); 
fclose(fid);

sk = size(key,2);

d=dec2bin(x,8).';
D = double(d(:).')-48;

sx = size(D,2);

n = floor(sx/sk);
y = cat(2,repmat(key,1,n), key(1:sx-sk*n));

D1 = xor(D,y);
d1 = reshape(D1,8,[]).';
x1 = sum(d1.*2.^(7:-1:0),2);

fid=fopen(cipher_txt_filename,'w');
fwrite(fid,x1.');
fclose(fid);
end