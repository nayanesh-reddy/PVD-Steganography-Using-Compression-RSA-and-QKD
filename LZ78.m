%% LZ78 compression
clear; clc;

encode = 1;

% Encoding
%x = 'ABBCBCABABCAABCAAB';
x = 'BABAABRRRA';
%x = 'AABABBBABAABABBBABBABB'

% fid = fopen('stego.txt','r');
% x = char(fread(fid)');
% fclose(fid);

% Decoding
L1 = [0 0 2 3 2 4 6];
S1 = 'ABCAAAB';
% load('L.mat'); load('S.mat');
% L1 = L;  S1 = char(strjoin(S,''));
% clear L S

tic;
%% Econding
if encode
    y=x;
    
    dict = "";
    i=0; J=1;
    while ~isempty(y)
        if J>size(y,2); break; end
        
        z = string(y(1:J));
        f = find(dict == z);
        c = char(z);
        
        if isempty(dict) || isempty(f)
            c = char(z);
            k = size(c,2);
            
            k = (k==1) + (k~=1)*(k);
            y(1:k)=[];
            
            J=1;   i=i+1;
            index(i) = i;     
            dict(i)   = z;
            
            if size(c,2)>1
                S(i) = string(c(end));
                L(i) =  find(dict==string( c(1:end-1) ));
            else
                S(i) = string(c(end));
                L(i) =  0;
            end
            
        else
            J = J + 1;
        end
        
    end
    
    idx = string(index);
    if ~isempty(y)
        S(end+1) = "";
        L(end+1) = find(dict==string(y));
        idx(end+1)  = "";
        dict(end+1)   = "";
    end
    
    output = repmat("( ",size(L,2),1) + string(L.') + repmat(" , ",size(L,2),1) + S.' + repmat(" )",size(L,2),1);
    
    sb = floor(log2(0:size(L,2)-1))+1; sb(sb<0)=1; 
    for i = 1:size(L,2) 
        p(i) = string(dec2bin(L(i),sb(i)));
    end
    
    A = cat(2,["output";output], ["index";idx.'], ["string";dict.']); disp(A)
    fprintf("compressed_msg = %s\n",strjoin(output,''));
    fprintf("actual compressed_msg = %s\n",strjoin(p+S,''));
    acmsg = strjoin(p+S,'');
    
    % Compression Ratio
    CR = (size(x,2)*8) / ( ( length(S) - sum(S=="") )*8 + sum(sb) );
    fprintf("\nCompression Ratio : %f\n\n",CR);
end
toc;
%% Decoding
if ~encode
   
    S1 = string(S1.').';
    
    for i=1:size(L1,2)
        index(i)  = i;
        if L1(i)==0
            dict(i)   =  S1(i);
        else
            dict(i) = dict(L1(i)) + S1(i);
        end
        output(i) =  dict(i);    
    end
    
    A = cat(2,["output";output.'], ["index";index.'], ["string";dict.']); disp(A)
    fprintf("decompressed_msg = %s\n",strjoin(output,''));
end