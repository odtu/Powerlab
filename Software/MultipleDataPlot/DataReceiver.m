clc
clear
fclose(instrfind) % call this command for stopping callback function
%% GLOBAL VARIABLES
% global variables are used for communication between the main function and
% the callback function
global SerialReadArray                          %the read values are put here first, in bytes
global TheRawDataIsInProcessFlag                %when this is set to 1, the main function shows the WindowArea of received data to the user, used for live visualizing of the main signal
global RawDataArray                             %This is the raw data array, inside which the all received data is put. This array is saved along with the tags when the received number of bytes reaches ProcessRawDataThresholdInBytes value
global GoToGarbage                              %During the processing of RawDataArray, a little bit of data goes to garbage
global CallbackFunctionByteNumber               %This value states when to call the callback function
global ProcessRawDataThresholdInBytes           %This value is the number of bytes of data to be saved as raw data (RawDataArray)
%% CONSTANT DEFINITIONS
BaudRateValue = 921600;                         %921600 is the maximum baudrate value for now
TimeoutValue = 6;                               %Allowed time in seconds to complete read and write operations, returned as a numeric value.
TheTag = 'hsrc';                                %the tag which is put in front of every float data, the tag should match the tag used in the DSP
TheTagByteSize = 4;                             %the byte size of the tag
NumberOfFloatsPerPacket = 20;                    %number of floats to be sent at one sending
CallbackFunctionByteNumber=512;                 %the callback function is called when this amount of bytes are read from the channel
%% VARIABLE DEFINITIONS
EnableSaving = 0;                               %set 0 in order to disable saving of the received data (recommended to stay at 1)
% ProcessRawDataThresholdInBytes = 2048*50*20;       %the received data will be saved and/or converted and plotted when ProcessRawDataThresholdInBytes bytes of data is received
ProcessRawDataThresholdInBytes = 2048*20*1;       %the received data will be saved and/or converted and plotted when ProcessRawDataThresholdInBytes bytes of data is received
EnablePlotting = 1;                             %set 0 in order to disable plotting of taken variables (for live visualization)
DataSampleRate = 1000;                          %this used for determinining the tag on the plots
TheSerialChannelDevice = 'COM4';                %set the serial channel device, (this value can be found the device manager)

%% Main function
TheRawDataIsInProcessFlag = 0;                  %initialize the variable
RawDataArray = zeros(ProcessRawDataThresholdInBytes,1);      %initialize the variable
TheTagValue = zeros(6,4);                       %initialize the variable


SerialChannel = serial(TheSerialChannelDevice,'BaudRate',BaudRateValue,'Parity','none','Timeout',6);    %open the serial channel
SerialChannel.BytesAvailableFcnCount = CallbackFunctionByteNumber;  %set the callback function byte number
SerialChannel.InputBufferSize = ProcessRawDataThresholdInBytes*2;
SerialChannel.BytesAvailableFcnMode = "byte";                       %set the callback function type
SerialChannel.BytesAvailableFcn = @SerialReadCallbackFunction;      %state the callback function to be called
fopen(SerialChannel);                                               %open the serial channel port
if (EnableSaving==1)
    mkdir TestData                              %create directory for saving data
end
while(1)
    if(TheRawDataIsInProcessFlag==1)
        TheTagValue = zeros(6,4);
        %IsMainSignalOffsetProper = 0;
        TheTagIndices = 0;
        TheDataConvertedValues = 0;
        TheSaveArrayScreened = RawDataArray;%RawDataArray(RawDataIndexPrevious:(RawDataIndexPrevious+WindowArea),1);
        TheTagIndices = strfind(TheSaveArrayScreened',TheTag);
        if(isempty(TheTagIndices)==0)
            for i=1:(numel(TheTagIndices))
                if(i+TheTagIndices(i)+4*6)<numel(TheSaveArrayScreened)
                    if(TheTagIndices(i)-TheTagIndices(i+1))~=(-(TheTagByteSize+4*NumberOfFloatsPerPacket))
                        fprintf("Deficient data. Some part of the data will not be transformed, saved and/or plotted\n");
                        break;
                    end
                    for a=1:NumberOfFloatsPerPacket
                        TheTagValue(a,1) = TheSaveArrayScreened(TheTagIndices(i)+TheTagByteSize+0+(a-1)*4);
                        TheTagValue(a,2) = TheSaveArrayScreened(TheTagIndices(i)+TheTagByteSize+1+(a-1)*4);
                        TheTagValue(a,3) = TheSaveArrayScreened(TheTagIndices(i)+TheTagByteSize+2+(a-1)*4);
                        TheTagValue(a,4) = TheSaveArrayScreened(TheTagIndices(i)+TheTagByteSize+3+(a-1)*4);
                        TheDataConvertedValues(a,i) = typecast(uint32(hex2dec(strcat(dec2hex(TheTagValue(a,4),2),dec2hex(TheTagValue(a,3),2),dec2hex(TheTagValue(a,2),2),dec2hex(TheTagValue(a,1),2)))),'single');
                    end
                end
            end
            if (EnablePlotting==1)  %for live visualization
                for i=1:NumberOfFloatsPerPacket
                    if(numel(TheDataConvertedValues)==1)
                       break; 
                    end
                    subplot(5,4,i)
                    plot((1:numel(TheDataConvertedValues(i,:)))/DataSampleRate,TheDataConvertedValues(i,:));
                    Text = sprintf('MeanValue: %f ',mean(TheDataConvertedValues(i,:)));
                    text(0,double(mean(TheDataConvertedValues(i,:))),Text, 'FontSize', 16,'FontWeight','bold')                    
%                     ylim([-4 4])
                    grid on
                end
                TheDataConvertedValues = 0;
                drawnow;
            end
            
        end
        TheRawDataIsInProcessFlag = 0;
        if(EnableSaving==1)
            FileName = sprintf("TestData/TestData_TwoModule_id1_iq1_id2_id2_wmech_wref_%s", datestr(now, 'ddmmyyHHMMSS'));
            save(FileName,'RawDataArray','TheTag','TheTagByteSize','NumberOfFloatsPerPacket','DataSampleRate');
            RawDataArray = 0;
            TheRawDataIsInProcessFlag = 0;
        else
            RawDataArray = 0;
            TheRawDataIsInProcessFlag = 0;
        end
    else
        pause(0.001);
    end
    
end

%% The callback function

function [] =  SerialReadCallbackFunction(TheSerialChannel,TheEvent)
global CallbackFunctionByteNumber   %the callback function is trigger when this number of bytes have been received
global SerialReadArray              %the read values are put here first
global RawDataArray                 %The callback function stores the data inside this large array, initialized inside the main function
global GoToGarbage                  %During the saving of RawDataArray, a little bit of data goes to garbage
global TheRawDataIsInProcessFlag    %This is just a flag, for non user operations
global ProcessRawDataThresholdInBytes            %This value is the number of bytes of data to be saved as raw data (RawDataArray)

if(TheSerialChannel.BytesAvailable==0)
    return;
end
if(TheRawDataIsInProcessFlag == 0)
    % fill in the raw data array
    SerialReadArray = fread(TheSerialChannel,TheSerialChannel.BytesAvailable);
    RawDataArray = cat(1,RawDataArray,SerialReadArray);
else
    %it means we are saving right now, dont mess with the raw data array for a
    %little while, be a patient fellow.
    GoToGarbage = fread(TheSerialChannel,TheSerialChannel.BytesAvailable); %just read and pass, dont store , otherwise the callback does not work
    return;
end
if(numel(RawDataArray) >= ProcessRawDataThresholdInBytes)
    % Raw data has reached to its specified limit, just save it and wait
    % for new data when the saving operation has finished
    TheRawDataIsInProcessFlag = 1;
end
end