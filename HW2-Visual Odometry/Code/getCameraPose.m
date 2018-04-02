function [Csolutions, Rsolutions, translateVector1, translateVector2, R1, R2] = getCameraPose( E )
%GETCAMERAPOSE Summary of this function goes here
%   Detailed explanation goes here

W1 = rotz(90);
W2 = rotz(-90);

[U,S,V] = svd(E);

T1 = U*W1*S*U';
T2 = U*W2*S*U';

translateVector1 = [T1(3,2); T1(1,3); T1(2,1)];
translateVector2 = [T2(3,2); T2(1,3); T2(2,1)];

R1 = U*W1'*V';
R2 = U*W2'*V';

if(det(R1) < 0)
    R1 = -R1;
end

if(det(R2) < 0)
    R2 = -R2;
end

Csolutions(:,:,1) = translateVector1;
Rsolutions(:,:,1) = R1;

Csolutions(:,:,2) = translateVector2;
Rsolutions(:,:,2) = R1;

Csolutions(:,:,3) = translateVector1;
Rsolutions(:,:,3) = R2;

Csolutions(:,:,4) = translateVector2;
Rsolutions(:,:,4) = R2;


end

