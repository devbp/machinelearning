%This is the main program. Run this program and you can go to different
%options Click the option as your choice

close all;
clear all;
set(0,'DefaultFigureWindowStyle','docked');
%adhoc parameter initialization for ESN
netDim = 50; connectivity = 0.3; inputLength = 1; outputLength = 1;
samplelength = 7000;
specRad = 0.5; ofbSC = [0]; noiselevel = 0.000; 
linearOutputUnits = 1; linearNetwork =0; WienerHopf = 0; 
initialRunlength = 1000; sampleRunlength = 3000; freeRunlength =0; plotRunlength = 2000;
inputscaling = [0.5]; inputshift = [0];
teacherscaling = [0.5]; teachershift = [0];
generateNet;
 createEmptyFigs;
 generatestochasticsignal;
 opt=1;
while opt==1
    
  close all;  
choice = menu('CONTROLING SLOW OBSERVABLES OF RECURRENT NEURAL NETWORK  PLEASE CHOOSE THE  OPTIONS BY CLICKING...After seeing output go to command prompt','LEARN AND TEST UNMODULATED SIGNAL','LEARN AND TEST MODULATED SIGNAL'...
    ,'LEARN AND TEST MODULATED SIGNAL WITH CONTROLLER','QUIT');

 if choice==1
  generateTrainTestDataUnmodulated;
learnAndTest_unmodulated;   
 end
 
 if choice==2
     generateTrainTestDatamodulated;
 learnAndTestWithoutcontroller; 
 end
 
if choice==3
generateTrainTestDatamodulated;
GenerateObserver;    
 Traincontroller;
 LearnAndTestwithcontroller;    
end
if choice==4
    quit();
end
opt = input('DO YOU WANT TOCONTINUE THE PROGRAM 1 FOR YES 2 FOR NO');

end

