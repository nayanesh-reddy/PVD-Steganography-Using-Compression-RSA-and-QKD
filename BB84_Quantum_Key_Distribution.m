clear; clc

O = [1;
     0];

X = [0 1;
     1 0]; 

H = (1/sqrt(2))*[1  1;
                 1 -1];


rng('shuffle','multFibonacci')    % Pseudo Random Generator

simulation = 20;
for n=1:1000
for s=1:simulation
%% Alice
alice_bits  = randi([0,1],1,n);
alice_bases = randi([0,1],1,n);

for i=1:n
    if alice_bits(i)==0
        b=O;
    else
        b=X*O;
    end
    
    if alice_bases(i)==1
        message(:,i) = H*b;
    else
        message(:,i) = b;
    end
end

%% Eaves
eaves_bases = randi([0,1],1,n);

for i=1:n
    if eaves_bases(i)==1
        m = sum([0,1]*H*message(:,i))^2;
    else
        m = sum([0,1]*message(:,i))^2;
    end
    
    if round(m,1)==0.5
        em = randi([0,1],1,1);
        if eaves_bases(i)==1
            message(:,i) = H*(O*(em==0) + X*O*(em==1));
        else
            message(:,i) = O*(em==0) + X*O*(em==1);
        end
    else
        em = m;
    end
    
    eaves_measure(1,i) = em;
end

%% Bob
bob_bases = randi([0,1],1,n);

for i=1:n
    if bob_bases(i)==1
        m = sum([0,1]*H*message(:,i))^2;
    else
        m = sum([0,1]*message(:,i))^2;
    end
    
    if round(m,1)==0.5
        bob_measure(1,i) = randi([0,1],1,1);
    else
        bob_measure(1,i) = m;
    end

end

j=0;
for i=1:n
    if alice_bases(i)==bob_bases(i)
        j=j+1;
        alice_key(j) = alice_bits(i);
        bob_key(j)   = round(bob_measure(i));
    end
end

if sum(alice_key == bob_key) == j
    E(s) = 0;
else
    E(s) = 1;
end
end

Ps(n) = sum(E==0)/simulation;
%K(n) = sum(E==1)/simulation;
Pt(n) = 0.75^n;
%fprintf('P(no eavesdropping)[simulation] = %f\n',sum(P)/p)
%fprintf('P(no eavesdropping)[theoretical] = %f\n',0.75^n)
end

plot(Ps,'Linewidth',1.4); hold on;
plot(Pt,'--','Linewidth',1.4); hold off;
title('BB84 Protocol for Quantum Key Distribution')
xlabel('no of bits (n)'); ylabel('P(undetected)')
legend('P[simulation]','P[theoretical]')
grid on
%clear