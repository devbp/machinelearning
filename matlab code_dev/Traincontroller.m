
Length=size(reservior,2);
statemean=mean(reservior,2);  %size of reservoir netdim*Length
repeatedmatrix=repmat(statemean,1,Length);
centeredreservior=repeatedmatrix-reservior;  %centering of the data around the mean

%normalizedcomponent=FindPrincipalcomponent(slowsignalofreservior);

observermean=mean(slowsignalofreservior,2);
repeat=repmat(observermean,1,Length);
 %[comp score]=princomp(x');  %finding the principle components of slow signals
% maincomp=comp(:,1:4);    %selecting the four columns as colums lie decreasing order of the principal component   
centeredobserver=slowsignalofreservior-repeat;
correlationobservermatrix=centeredobserver*centeredobserver';
 %po=(score*maincomp)  %four principal omponent of each time stamp data
[U S V]=svd(correlationobservermatrix);
%size(U)
maincomp=U(:,1:4);
size(maincomp)
po=maincomp'*centeredobserver;   %size of 4*runlength


transpo=po';
[R,C]=size(transpo);
figure;
plot(transpo(1:2000,:) );
title('principle component');

stdeviation=std(po,0,2); 
%nn=transpo./repmat(stdeviation,R,1);
 inversquar=stdeviation.^(-1);
  deviations=repmat(inversquar,1,Length);
%  size(deviations)
%  size(inversquar)
 diagonalmatrix=diag(inversquar)
% %flip=flipud(inversquar);
 %diagonalmatrix=diag(flip);  %creating the diagonal matrix
% % 
% % % pr=d*po'
% % figure;
% size(diagonalmatrix)
 normalizedcomponent=(deviations.*po);
 %normalized principal component
 %normalizedcomponent=nn;
 figure;
  plot((normalizedcomponent(:,1:4000))');
  title('Normalized Principle Component');

firstcomponent=zeros(Length,1);
%normalizedcomponent=po;
controller=zeros(netDim,4);
for i=1:4     % calculating four controllers

firstcomponent=normalizedcomponent(i,:);
size(firstcomponent);
repeatfirstcomp=repmat(firstcomponent,netDim,1);
correlation=repeatfirstcomp.*centeredreservior;
m=mean(correlation,2);
controller(:,i)=m;
end

%  gain=[40 0 0 0];  %four gains for the four controllers
% controller=controller';  % transpose of thecontroller
  figure;
 plot(controller);
 title('Four Controller');
%  controllervector=zeros(Length,netDim);  
%  normalizedcomponent=normalizedcomponent';
%  for i=1:4
%      controllervector=controllervector+(normalizedcomponent(:,i)*controller(i,:)).*gain(:,i);
%  end
% % figure;
% %  plot(controllervector(1:1000,1:10));
% %  title('controller internal states');


