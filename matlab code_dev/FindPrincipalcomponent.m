function [po] = FindPrincipalcomponent(x)
Length=size(x,2);

observermean=mean(x,2);
repeat=repmat(observermean,1,Length);
 %[comp score]=princomp(x');  %finding the principle components of slow signals
% maincomp=comp(:,1:4);    %selecting the four columns as colums lie decreasing order of the principal component   
centeredobserver=x-repeat;
correlationobservermatrix=centeredobserver*centeredobserver';
 %po=(score*maincomp)  %four principal omponent of each time stamp data
[U S V]=svd(correlationobservermatrix);
%size(U)
maincomp=U(:,1:4);
size(maincomp)
po=maincomp'*centeredobserver;   %size of 4*runlength
size(po)

transpo=po';
figure;
plot(transpo(1:2000,:) );
title('principle component');

 stdeviation=std(po,0,2); 
 inversquar=stdeviation.^(-1);
 diagonalmatrix=diag(inversquar);
% %flip=flipud(inversquar);
% % diagonalmatrix=diag(flip);  %creating the diagonal matrix
% % 
% % % pr=d*po'
% % figure;
% size(diagonalmatrix)
 normalizedcomponent=(diagonalmatrix*po);              %normalized principal component
figure;
  plot((normalizedcomponent(:,1:3000))');
  title('Normalized Principle Component');
% 
 %controller=centeredreservior*normalizedcomponent'; % size 4*netdim
% %c=mean(controller,1);
% 
end

