function [PX,PY] = hilbert_fractal_generating(order)
%creating hilbert fractal
a = 1 + 1i;
b = 1 - 1i;
z = 0;
for k = 1:order
    w = 1i*conj(z);
    z = [w-a; z-b; z+a; b-w]/2;
end

%creating two column matrices which helps in tracing hilbert fractal
for f=2:size(z,1)
l(f-1,1)=isreal(z(f-1)-z(f));
if(l(f-1,1)==0)
    h(f-1,1)=1i*(z(f-1)-z(f));
    if(h(f-1,1)>0)
        h(f-1,1)=1;
    else
        h(f-1,1)=0;
    end
else
    h(f-1,1)=-(z(f-1)-z(f));
    if(h(f-1,1)>0)
        h(f-1,1)=1;
    else
        h(f-1,1)=0;
    end
end
end
%plot(z);
h=logical(h);

x=2^order; y=1;

PX=[x];PY=[y];
for n=1:size(l,1)
    if(l(n,1) && h(n,1))
        y=y+1;
    elseif(l(n,1) && ~h(n,1))
        y=y-1;
    elseif(~l(n,1) && h(n,1))
        x=x-1;
    else
        x=x+1;
    end
    PX(n+1)=x;PY(n+1)=y;
 
end

%save("hilbert_order"+string(order)+".mat",'PX','PY')
end