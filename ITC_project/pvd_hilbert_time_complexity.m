clear; clc; close all

%read image
img = imread('Lena.png');

%read text file
file_id = fopen('SampleText.txt','r');
file_content = fread(file_id);
file_length = length(file_content);

in = dec2bin(file_content',8)';
in = in(:)';

%%

iv = 3; fv = 9;
ORDER = iv:fv;
for order = ORDER
    %% Hilbert factral pattern
    
    [PX,PY] = hilbert_fractal_generating(order);
    
    clearvars -except time order ORDER time_hiding time_extract in img PX PY iv fv
    
    tic;
    lb=[0 8 16 32 64 128]; %lowerbound
    ub=[7 15 31 63 127 255]; %upperbound
    
    img = imresize(img,[2^order,2^order]);
    
    stego=img;
    ptr=1;
    
    %% Encoding
    index = 1;
    tic;
    for pl=1:3
        for i=1:2:length(PX)
            %tic;
            p=[];
            %enable = 1; %enable=0 when new pixels may fall off the boundary
            p = [img(PX(i),PY(i),pl) img(PX(i+1),PY(i+1),pl)]; %block of two pixels, pi & pi+1
            p = double(p);
            d = abs( p(1,2) - p(1,1)); %d = difference between 2 pixel%%d=0
            
            if(d<=3)
                R=1;%%r=1
            else
                R=floor(log2(d))-1;
            end
            t=floor(log2(ub(R)-lb(R)+1));%%t=3
            if(ptr+t>length(in))
                break
                %break
            else
                dprime=lb(R)+ bin2dec(in(ptr:ptr+t-1));%%%dp=0+2
                ptr=ptr+t;
                m=abs(dprime-d);%m=2
                if(p(1)>=p(2))
                    if(dprime>d)
                        p=[p(1)+ceil(m/2) p(2)-floor(m/2)];%%p=p(1)+1 p(2)-1
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
                stego(PX(i),PY(i),pl)=uint8(p(1)); stego(PX(i+1),PY(i+1),pl)=uint8(p(2));
            end
            %end
            %th(index) = toc;
            index=index+1;
        end
    end
    time_hiding(order) = toc;
    %figure
    %imshow(stego,'initialmagnification','fit'); title("Stego image");
    
    %% Decoding
    
    i=0;
    remaining_length=length(in);
    
    tic;
    for pl=1:3
        for j=1:2:length(PX)
            %tic;
            p=[];
            %enable = 1; %enable=0 when new pixels may fall off the boundary
            p = [stego(PX(j),PY(j),pl) stego(PX(j+1),PY(j+1),pl)]; %block of two pixels, pi & pi+1
            p=double(p);
            d =abs( p(1,2) - p(1,1)); %d = difference between 2 pixel
            
            if(d<=3); R=1; else;R=floor(log2(d))-1; end
            
            t=floor(log2(ub(R)-lb(R)+1));
            
            if(remaining_length<=0)
                break
                %break
            else
                data=dec2bin(d-lb(R),t);
                remaining_length=remaining_length-t;
                i=i+1;
                out(i) = string(data);
            end
            %te(index) = toc;
            index=index+1;
        end
    end
    
    
    txtout = char(strjoin(out,''));
    
    %txt = string(zeros(1,(floor(length(txtout)/8))));
    for i = 1:(floor(length(txtout)/8))
        txt(i) = string(txtout(8*(i-1) + 1 : 8*i));
    end
    txt = bin2dec(txt);
    txt = char(txt);
    
    time_extract(order) = toc;
    
    %time(order) = toc;
end

%% Plotting

o = 1:10;
n = 2.^(2*o);
ip=3*n;
op=1.5*n;
clc
th = op*2.6*10^-6;
te = op*4.9*10^-6;

% Semilog x-axis
figure(1);
semilogx(ip(iv:fv) ,time_hiding(iv:end),'*-',...
        ip(iv:fv) ,time_extract(iv:end),'*-',...
        ip(iv:fv),th(iv:fv),'--o', ip(iv:fv),te(iv:fv),'--o','LineWidth',1.5)

grid on ;title('Time Complexity O(n)')
xlabel('Inputs(n)') ;ylabel('Time (seconds)')
legend('hiding','extracting','hiding theoretical','extracting theoretical')

% Linear x-axis
figure(2);
plot(ip(iv:fv) ,time_hiding(iv:end),'*-',...
        ip(iv:fv) ,time_extract(iv:end),'*-',...
        ip(iv:fv),th(iv:fv),'--o', ip(iv:fv),te(iv:fv),'--o','LineWidth',1.5)

grid on ;title('Time Complexity O(n)')
xlabel('Inputs(n)') ;ylabel('Time (seconds)')
legend('hiding','extracting','hiding theoretical','extracting theoretical')

