
% t=0:0.1:1;
% y1=sin(2*pi*t);
% figure;
% plot(t,y1);
% t=0:0.1:1;
% figure;
% y2=sin(2*2*pi*t);
% plot(t,y2);



mysignal=zeros(1,10000);

if(rand(1,1)<0.5)
    sw=1;
else 
    sw=0;
end
 
i=1;
for t=1:0.1:1000
     
if(sw==1)
    mysignal(i)=sin(2*pi*t);
         if(rand(1,1)<0.02)
              sw=0; 
         else 
             sw=1;
         end
            
elseif(sw==0)

    mysignal(i)=sin(2*2*pi*t);
    if(rand(1,1)<0.02)
        sw=1;
           else 
                 sw=0;
    end   
end 

i=i+1;

end
figure;
plot(mysignal);
% index
% figure
% t=0:0.01:runtime;
% size(t);
% plot(mysignal(1:1000))
% title('stotimestamphastitimestamp signal')
% grid on
% 
signalsize=size(mysignal,2)
 noiselength=[1:1:signalsize];
 Amplitude =2;
 frequentimestampy =1/1000;
 noise= Amplitude*sin(2*pi*frequentimestampy*noiselength);
% noisesize=size(noise);
%  figure;
% plot(noise(:,1:1000));
%   title('slow noise');
%   
% figure;
%  distortednoise=mysignal+noise;
%  plot(distortednoise);
