

disp('Generating data ............');


  sampleinput = rand(1,samplelength);
   slownoise=zeros(1,samplelength);
 sampleout = zeros(1,samplelength);

 
 sampleout=mysignal(:,2:samplelength);
 sampleinput=mysignal(:,1:samplelength-1);
slownoise=noise(:,1:samplelength-1);
 %distortedsignal=slownoise+sampleinput;

 %sampleinput=distortedsignal;


% %normalize input to range [0,0.5]
% for indim = 1:length(sampleinput(:,1))
%     maxVal = max(sampleinput(indim,:)); minVal = min(sampleinput(indim,:));
%     if maxVal - minVal > 0
%       sampleinput(indim,:) = (sampleinput(indim,:) - minVal)/(maxVal - minVal)-0.5;
%     end
% end

% find the distorted signal
distortedsignal=slownoise+sampleinput;
 sampleinput=distortedsignal; % now the input signal is distorted signal
% normalize output to range [-0.5,0.5]
% for outdim = 1:length(sampleout(:,1))
%     maxVal = max(sampleout(outdim,:)); minVal = min(sampleout(outdim,:));
%     if maxVal - minVal > 0
%        sampleout(outdim,:) = (sampleout(outdim,:) - minVal)/(maxVal - minVal)-0.5;
%     end
% end

% plot generated sampleout
figure;
outdim = length(sampleout(:,1));
for k = 1:outdim
    subplot(outdim, 1, k);
    plot(sampleout(k,:));
    if k == 1
        title('sampleout','FontSize',8);
    end
end
    
% plot generated sampleinput
figure;
outdim = length(sampleinput(:,1));
for k = 1:outdim
    subplot(outdim, 1, k);
    plot(sampleinput(k,:));
    if k == 1
        title('sampleinput','FontSize',8);
    end
end
    
