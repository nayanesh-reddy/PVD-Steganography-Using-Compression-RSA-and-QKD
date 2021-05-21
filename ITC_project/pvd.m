function output = pvd( type, img, in, PX, PY )
    
    type = string(type);
    stego_img = img;

    lb=[0 8 16 32 64 128]; %lowerbound
    ub=[7 15 31 63 127 255]; %upperbound

    in = [ dec2bin( size(in,2), 32) in ];

    %% Encoding 
    
    if type == "encoding" 
        ptr = 1;

        for pl=1:3
            for i=1:2:length(PX)
                p=[];

                p = [img(PX(i),PY(i),pl) img(PX(i+1),PY(i+1),pl)]; %block of two pixels, pi & pi+1
                p = double(p);
                d = abs( p(1,2) - p(1,1)); %d = difference between 2 pixel

                if(d<=3)
                    R=1;
                else
                    R=floor(log2(d))-1;
                end
                t=floor(log2(ub(R)-lb(R)+1));
                if(ptr+t>length(in))
                    break

                else
                    dprime=lb(R)+ bin2dec(in(ptr:ptr+t-1));
                    ptr=ptr+t;
                    m=abs(dprime-d);
                    if(p(1)>=p(2))
                        if(dprime>d)
                            p=[p(1)+ceil(m/2) p(2)-floor(m/2)];
                        else
                            p=[p(1)-ceil(m/2) p(2)+floor(m/2)];
                        end
                    else
                        if(dprime>d)
                            p=[p(1)-floor(m/2) p(2)+ceil(m/2)];
                        else
                            p=[p(1)+ceil(m/2) p(2)-floor(m/2)];
                        end
                    end
                    stego_img(PX(i),PY(i),pl)=uint8(p(1)); stego_img(PX(i+1),PY(i+1),pl)=uint8(p(2));
                end

            end
        end
        
        output = stego_img;
        
    else
    %% Decoding
    
        i=0; len=0; f=0;
        remaining_length = Inf;

        for pl=1:3
            for j=1:2:length(PX)
                p=[];
                
                %fprintf("%d %d\n",pl,j);
                
                p = [stego_img(PX(j),PY(j),pl) stego_img(PX(j+1),PY(j+1),pl)]; %block of two pixels, pi & pi+1
                p = double(p);
                d = abs( p(1,2) - p(1,1)); %d = difference between 2 pixel

                if(d<=3); R=1; else;R=floor(log2(d))-1; end

                t=floor(log2(ub(R)-lb(R)+1));
                
                if(remaining_length<=0)
                    break

                else
                    data=dec2bin(d-lb(R),t);
                    remaining_length = remaining_length - t;
                    i=i+1;
                    out(i) = string(data);
                end
                
                if f==0
                    len = len + t;
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

        txt = bin2dec(txt);
        txt = char(txt); 
        
        output = txt(5:end);
    end
    
end