function [alice_key, bob_key] = QKD(n,eavesdropping)

% |0>
O = [1;
     0];
 
% X gate
X = [0 1;
     1 0]; 
 
% Hadamard gate
H = (1/sqrt(2))*[1  1;
                 1 -1];
             
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
if eavesdropping
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

%% Key creation
j=0;
for i=1:n
    if alice_bases(i)==bob_bases(i)
        j=j+1;
        alice_key(j) = alice_bits(i);
        bob_key(j)   = round(bob_measure(i));
    end
end

%if eavesdropping == 11; return; end
%QKD(n,eavesdropping+1);

%% Detecting Eaves Presence
%if sum(alice_key == bob_key) == j
%    key = alice_key;
%else
%    key = 'Eavesdropper found';
%end

end