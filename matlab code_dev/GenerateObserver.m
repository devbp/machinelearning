

plotStates = [12,13,14,15,16,17,8,7,10]; % plot internal network states of ...


disp('Generating smoothed internal states.........');
% disp(sprintf('netDim = %g   specRad =  %g   noise = %g    ',...
%     netDim, specRad, noiselevel));
% disp(sprintf('output feedback Scaling = %s', num2str(ofbSC')));
% disp(sprintf('inSC = %s', num2str(inputscaling')));
% disp(sprintf('inShift = %s', num2str(inputshift')));
% disp(sprintf('teacherSC = %s', num2str(teacherscaling')));
% disp(sprintf('teachershift = %s', num2str(teachershift')));
% disp(sprintf('WienerHopf = %g   linearOuts = %g   linearNet = %g',...
%     WienerHopf,linearOutputUnits, linearNetwork));
% disp(sprintf('initRL = %g  sampleRL = %g  plotRL = %g  ',...
%     initialRunlength, sampleRunlength, plotRunlength));


totalstate =  zeros(totalDim-1,1);    
internalState = totalstate(1:netDim);   
size(internalState);

intWM = intWM0 * specRad;
ofbWM = ofbWM0 * diag(ofbSC);
outWM = initialOutWM;
stateCollectMat = zeros(sampleRunlength, netDim + inputLength);
teachCollectMat = zeros(sampleRunlength, outputLength);
teacherPL = zeros(outputLength, plotRunlength);
netOutPL = zeros(outputLength, plotRunlength);


%observer=internalState(1:netDim);  %  creating observer variable
observer=zeros(netDim,1);
old_observer=zeros(netDim,1);
slowsignalofreservior=[];

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
           
   
        if i > initialRunlength 
              
       val= [intWM, inWM];
            s=[intWM, inWM]*totalstate;
             internalState = f(s);  
             totalstate = [internalState;in];
        end
%          val= [intWM, inWM, ofbWM];
%             s=[intWM, inWM, ofbWM]*totalstate;
%              internalState = f(s);  
%              totalstate = [internalState;in;netOut];    
       %adding the reserviors signals
   
       if i>initialRunlength
        reservior=[reservior,internalState];
    observer=observer*0.98+internalState*0.02;    %computing observer
    %old_observer=observer;
    slowsignalofreservior=[slowsignalofreservior,observer];    
        end
        
        
    % adding slow observers 
end


 figure(fig6);
 title('Observers');
    %plotting observers of different states
 for state=1:9
  subplot(3,3,state);
    plot(slowsignalofreservior(state,initialRunlength:initialRunlength+2000));
  title('smoothed Observers without controller');
 end
   
