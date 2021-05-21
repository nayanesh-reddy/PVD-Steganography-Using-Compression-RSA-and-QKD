function txt = LZ78_decompression(compressed_txt_filename, output_txt_filename)

    fid = fopen(compressed_txt_filename,'r');
    file_content = char(fread(fid)');
    fclose(fid);
    
    x = dec2bin(file_content',8)';
    x = x(:)';
    
    sz = bin2dec(x(1:32));
    x(1:32) = [];

    sb = floor(log2(0:sz-1))+1; sb(sb<0)=1;
    
    for i = 1:length(sb)
        if length(x) < sb(i) + 8
            break
        end
        
        L1(1,i) = bin2dec(x(1:sb(i))); 
        x(1:sb(i)) = [];
        
        S1(1,i) = string(char(bin2dec(x(1:8))));
        x(1:8) = [];
        
    end
    
    disp(x);
    disp(sb(i))
    
    for i=1:size(L1,2)
        if L1(i)==0
            dict(i)   =  S1(i);
        else
            %if L1(i) > length(dict); break; end
            dict(i) = dict(L1(i)) + S1(i);
        end
        output(i) =  dict(i); 
    end
    
    txt = char(strjoin(output,''));
    
    fid = fopen(output_txt_filename,'w');
    fwrite(fid, txt);
    fclose(fid);
    
end