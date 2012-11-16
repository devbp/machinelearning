
 

plotStates = [12,13,14,15,16,17,8,7,10]; % plot internal network states of ...


disp('Learning and testing without controller.........');

totalstate =  zeros(totalDim,1);    
internalState = totalstate(1:netDim);   
size(internalState);

intWM = intWM0 * specRad;
ofbWM = ofbWM0 * diag(ofbSC);
outWM = initialOutWM;
stateCollectMat = zeros(sampleRunlength, netDim + inputLength);
teachCollectMat = zeros(sampleRunlength, outputLength);
teacherPL = zeros(outputLength, plotRunlength);
netOutPL = zeros(outputLength, plotRunlength);


observer1=internalState(1:netDim);  %  creating observer variable
 observer1=zeros(netDim,1);
% old_observer=zeros(netDim,1);
 slowsignalofreservior1=[];
% 
reservior=[];
% figure
% plot(reservior);
% title('rr');


if inputLength > 0
    inputPL = zeros(inputLength, plotRunlength);
end
statePL = zeros(length(plotStates),plotRunlength);
plotindex = 0;
msetest = zeros(1,outputLength); 
msetrain = zeros(1,outputLength); 


for i = 1:initialRunlength + sampleRunlength + freeRunlength + plotRunlength % loop for the time stamp
    
    if inputLength > 0
        in = [diag(inputscaling) * sampleinput(:,i) + inputshift];  % in is column vector  
    else in = [];
    end
    teach = [diag(teacherscaling) * sampleout(:,i) + teachershift];    % teach is column vector     
    
    %write input into totalstate
    if inputLength > 0
        totalstate(netDim+1:netDim+inputLength) = in; 
    end
    %update totalstate except at input positions  
    if linearNetwork
        %if i > initialRunlength  %washout initial length
            internalState = ([intWM, inWM, ofbWM]*totalstate);  
       % end
    else
        if  i > initialRunlength 
            val= [intWM, inWM, ofbWM];
            s=[intWM, inWM, ofbWM]*totalstate;
           internalState = f(s);  
            end
    end
    
    if linearOutputUnits
        netOut = outWM *[internalState;in];
    else
        netOut = f(outWM *[internalState;in]);
    end
    totalstate = [internalState;in;netOut];    
if i> initialRunlength
 reservior=[reservior,internalState];   %adding the reserviors signals
     observer1=observer1*0.98+internalState*0.02;    %computing observer
%     old_observer=observer;
     slowsignalofreservior1=[slowsignalofreservior1,observer1]; % adding slow observers 
   end
    %collect states and results for later use in learning procedure
    if (i > initialRunlength) & (i <= initialRunlength + sampleRunlength) 
        collectIndex = i - initialRunlength;
        stateCollectMat(collectIndex,:) = [internalState' in']; %fill a row
        if linearOutputUnits
            teachCollectMat(collectIndex,:) = teach';
        else
            teachCollectMat(collectIndex,:) = (fInverse(teach))'; %fill a row
        end
    end
    %force teacher output 
    if i <= initialRunlength + sampleRunlength
        totalstate(netDim+inputLength+1:netDim+inputLength+outputLength) = teach; 
    end
    %update msetest
    if i > initialRunlength + sampleRunlength + freeRunlength
        for j = 1:outputLength
            msetest(1,j) = msetest(1,j) + (teach(j,1)- netOut(j,1))^2;
        end
    end
    %compute new model
    %update the outputweights
    if i == initialRunlength + sampleRunlength
        if WienerHopf
            covMat = stateCollectMat' * stateCollectMat / sampleRunlength;
            pVec = stateCollectMat' * teachCollectMat / sampleRunlength;
            outWM = (inv(covMat) * pVec)';
        else
            outWM = (pinv(stateCollectMat) * teachCollectMat)'; 
        end
        %compute mean square errors on the training data using the newly
        %computed weights
        for j = 1:outputLength
            if linearOutputUnits
                msetrain(1,j) = sum((teachCollectMat(:,j) - ...
                    (stateCollectMat * outWM(j,:)')).^2);
            else
                msetrain(1,j) = sum((f(teachCollectMat(:,j)) - ...
                    f(stateCollectMat * outWM(j,:)')).^2);
            end
            msetrain(1,j) = msetrain(1,j) / sampleRunlength;
        end
    end    
    %write plotting data into various plotfiles
    if i > initialRunlength + sampleRunlength + freeRunlength
        plotindex = plotindex + 1;
        if inputLength > 0
            inputPL(:,plotindex) = in;
        end
        teacherPL(:,plotindex) = teach; 
        netOutPL(:,plotindex) = netOut;
        for j = 1:length(plotStates)
            statePL(j,plotindex) = totalstate(plotStates(j),1);
        end
    end
end
%end of the great do-loop
pc=FindPrincipalcomponent(slowsignalofreservior1);
% print diagnostics in terms of normalized RMSE (root mean square error)

msetestresult = msetest / plotRunlength;
teacherVariance = var(teacherPL');
disp(sprintf('train NRMSE = %s', num2str(sqrt(msetrain ./ teacherVariance))));
disp(sprintf('test NRMSE = %s', num2str(sqrt(msetestresult ./ teacherVariance))));
disp(sprintf('average output weights = %s', num2str(mean(abs(outWM')))));



% input plot
% figure(fig2);
% subplot(inputLength,1,1);
% plot(inputPL(1,:));
% title('final effective inputs','FontSize',8);
% for k = 2:inputLength
%     subplot(inputLength,1,k);
%     plot(inputPL(k,:));
% end


% plot first 4 (maximally) of internal states listed in plotStates
if length(plotStates) > 0 
    figure(fig3);
    subplot(3,3,1);
    plot(statePL(1,:));
    title('internal states without controller','FontSize',8);
    for k = 2:length(plotStates)
        subplot(3,3,k);
        plot(statePL(k,:));
         title('internal states without controller','FontSize',8);
    end    
end

% plot weights
%  figure(fig6);
%  title('Observers');
%     %plotting observers of different states
%  for state=1:9
%   subplot(3,3,state);
%     plot(slowsignalofreservior(state,1:500));
%   title('Observers');
%  end
%        

     
     figure;
          %plotting reservior signal of states 1 to 9
 for state=1:9
       subplot(3,3,state);
 plot(reservior(state,1:initialRunlength+2000));
 title('Reserviors without controller');
 end
 
 figure;
 plot((reservior(45:48,initialRunlength:initialRunlength+2000))');
 title('reservior signals without controller');
  
%     subplot(3,3,2)
%  plot(reservior(2,:))
%  
 figure(fig4);
    subplot(outputLength,1,1);   
    plot(outWM(1,:));
    title('output weights without controller','FontSize',8);
    for k = 2:outputLength
        subplot(outputLength,1,k);
        plot(outWM(k,:));
    end  


% plot overlay of network output and teacher  
figure(fig5);
subplot(outputLength,1,1);   
plot(1:plotRunlength,teacherPL(1,:), 1:plotRunlength,netOutPL(1,:));
title('teacher (blue) vs. net output (green) without controller','FontSize',8);
for k = 2:outputLength
    subplot(outputLength,1,k);
    plot(1:plotRunlength,teacherPL(k,:), 1:plotRunlength,netOutPL(k,:));
end  





