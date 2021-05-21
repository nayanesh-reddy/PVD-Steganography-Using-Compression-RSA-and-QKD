function txt = LZ78_compression(input_text_filename, compressed_txt_filename)

    fid = fopen(input_text_filename,'r');
    x = char(fread(fid)');
    fclose(fid);

    y=x;

    dict = "";
    i=0; J=1;
    while ~isempty(y)
        if J>size(y,2); break; end

        z = string(y(1:J));
        f = find(dict == z, 1);

        if isempty(dict) || isempty(f)
            c = char(z);
            k = size(c,2);

            k = (k==1) + (k~=1)*(k);
            y(1:k)=[];

            J=1;   i=i+1;
            dict(i)   = z;

            if size(c,2)>1
                S(i) = string(c(end));
                L(i) = find(dict==string( c(1:end-1) ));
            else
                S(i) = string(c(end));
                L(i) =  0;
            end

        else
            J = J + 1;
        end
    end

    if ~isempty(y)
        S(end+1) = "";
        L(end+1) = find(dict==string(y));
        dict(end+1)   = "";
    end
    
    sb = floor(log2(0:size(L,2)-1))+1; sb(sb<0)=1;
    p  = string(zeros(1,size(sb,2)));
    
    for i = 1:size(L,2)
        p(i) = string(dec2bin(L(i),sb(i)));
    end
    
    acmsg = char(strjoin(p+string(dec2bin(char(S),8))',''));
    acmsg = [dec2bin(size(L,2),32) acmsg];
    
    for i = 1:(floor(length(acmsg)/8))
        txt(i) = string(acmsg(8*(i-1) + 1 : 8*i));
    end
    
    txt = char(bin2dec(txt));
    
    % Compression Ratio
    CR = (size(x,2)*8) / ( ( length(S) - sum(S=="") )*8 + sum(sb) );
    fprintf("\nCompression Ratio : %f\n\n",CR);
    
    fid = fopen(compressed_txt_filename,'w');
    fwrite(fid, txt);
    fclose(fid);
    
end