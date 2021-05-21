function output = klsb(k,type,img,in,PX,PY)

    in = [ dec2bin( size(in,2), 32) in ];
    
    if type=="encoding"
        %% Encoding
        st=img;
        ptr=1;
        for pl=1:3
            for i=1:length(PX)
                p = double(img(PX(i),PY(i),pl));
                
                if(ptr+k>length(in))
                    break
                    
                else
                    d=double(bin2dec(in(ptr:ptr+k-1)));
                    ptr=ptr+k;
                    if(mod(p,2^k)~=d && p<=2^k)
                        p=d;
                    elseif(mod(p,2^k)~=d && p>2^k)
                        p=(2^k)*floor(p/(2^k))+d;
                    end
                    st(PX(i),PY(i),pl)=uint8(p);
                end
            end
        end
        output=st;
    
        %% Decoding
    else
        i=0;len=0; f=0;
        
        remaining_length = Inf;
        
        for pl=1:3
            for j=1:length(PX)
                p=[];
                p = double(img(PX(j),PY(j),pl)) ;
                
                if(remaining_length<=0)
                    break
                    
                else
                    data=dec2bin(mod(p,2^k),k);
                    remaining_length=remaining_length-k;
                    i=i+1;
                    out(i) = string(data);
                end
                
                if f==0
                    len = len + k;
                end
                
                if len >= 32 && f==0
                    f=1;
                    L = char(strjoin(out,''));
                    remaining_length = bin2dec(L(1:32)) - len + 32;
                    len=0;
                end
                
            end
        end
    
        txtout = char(strjoin(out,''));
    
        for i = 1:(floor(length(txtout)/8))
            txt(i) = string(txtout(8*(i-1) + 1 : 8*i));
        end
        txt = char(bin2dec(txt));
        output = txt(5:end);
    end
end