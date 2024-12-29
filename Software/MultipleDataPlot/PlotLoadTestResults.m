clear
clc
close all
FontSize = 16;
% load('TestData/TestData301120212502.mat')
load('TestData/TestData_TwoModule_id1_iq1_id2_id2_wmech_wref_170321192604.mat')
EnablePlotting = 1;
TheTagValue = zeros(NumberOfFloatsPerPacket,4);
TheSaveArrayScreened = RawDataArray;
TheTagIndices = strfind(TheSaveArrayScreened',TheTag);
if(isempty(TheTagIndices)==0)
    for i=1:(numel(TheTagIndices)-1)
        if(i+TheTagIndices(i)+4*6)<numel(TheSaveArrayScreened)
            if(TheTagIndices(i)-TheTagIndices(i+1))~=(-(TheTagByteSize+4*NumberOfFloatsPerPacket))
                continue;
            end
            for a=1:NumberOfFloatsPerPacket
                TheTagValue(a,1) = TheSaveArrayScreened(TheTagIndices(i)+TheTagByteSize+0+(a-1)*4);
                TheTagValue(a,2) = TheSaveArrayScreened(TheTagIndices(i)+TheTagByteSize+1+(a-1)*4);
                TheTagValue(a,3) = TheSaveArrayScreened(TheTagIndices(i)+TheTagByteSize+2+(a-1)*4);
                TheTagValue(a,4) = TheSaveArrayScreened(TheTagIndices(i)+TheTagByteSize+3+(a-1)*4);
                TheDataConvertedValues_TestData1(a,i) = typecast(uint32(hex2dec(strcat(dec2hex(TheTagValue(a,4),2),dec2hex(TheTagValue(a,3),2),dec2hex(TheTagValue(a,2),2),dec2hex(TheTagValue(a,1),2)))),'single');
            end
        end
    end
    
end

% clear
load('TestData/TestData_TwoModule_id1_iq1_id2_id2_wmech_wref_240321084127.mat')
EnablePlotting = 1;
TheTagValue = zeros(NumberOfFloatsPerPacket,4);
TheSaveArrayScreened = RawDataArray;
TheTagIndices = strfind(TheSaveArrayScreened',TheTag);
if(isempty(TheTagIndices)==0)
    for i=1:(numel(TheTagIndices)-1)
        if(i+TheTagIndices(i)+4*6)<numel(TheSaveArrayScreened)
            if(TheTagIndices(i)-TheTagIndices(i+1))~=(-(TheTagByteSize+4*NumberOfFloatsPerPacket))
                continue;
            end
            for a=1:NumberOfFloatsPerPacket
                TheTagValue(a,1) = TheSaveArrayScreened(TheTagIndices(i)+TheTagByteSize+0+(a-1)*4);
                TheTagValue(a,2) = TheSaveArrayScreened(TheTagIndices(i)+TheTagByteSize+1+(a-1)*4);
                TheTagValue(a,3) = TheSaveArrayScreened(TheTagIndices(i)+TheTagByteSize+2+(a-1)*4);
                TheTagValue(a,4) = TheSaveArrayScreened(TheTagIndices(i)+TheTagByteSize+3+(a-1)*4);
                TheDataConvertedValues_TestData2(a,i) = typecast(uint32(hex2dec(strcat(dec2hex(TheTagValue(a,4),2),dec2hex(TheTagValue(a,3),2),dec2hex(TheTagValue(a,2),2),dec2hex(TheTagValue(a,1),2)))),'single');
            end
        end
    end
    
end

%% First make both datas the same size
for i=1:6
    if(numel(TheDataConvertedValues_TestData1(i,:))>numel(TheDataConvertedValues_TestData2(i,:)))
        %TheDataConvertedValues_TestData1(i,:) = TheDataConvertedValues_TestData1(i,1:numel(TheDataConvertedValues_TestData2));
        TheDataConvertedValues_TestData1(:,(numel(TheDataConvertedValues_TestData2(i,:))+1):end) = [];
    else if (numel(TheDataConvertedValues_TestData1(i,:))<numel(TheDataConvertedValues_TestData2(i,:)))
            TheDataConvertedValues_TestData2(:,(numel(TheDataConvertedValues_TestData1(i,:))+1):end) = [];
        end
        
    end
end


% figure
% for i=1:6
%     subplot(3,2,i)
%     plot((1:numel(TheDataConvertedValues_TestData1(i,:)))/DataSampleRate,TheDataConvertedValues_TestData1(i,:));
%     if(i==5)
%         hold on
%         plot((1:numel(TheDataConvertedValues_TestData1(6,:)))/DataSampleRate,TheDataConvertedValues_TestData1(6,:));
%         hold off
%     end
%     grid on
% end
% 
% figure
% for i=1:6
%     subplot(3,2,i)
%     plot((1:numel(TheDataConvertedValues_TestData2(i,:)))/DataSampleRate,TheDataConvertedValues_TestData2(i,:));
%     if(i==5)
%         hold on
%         plot((1:numel(TheDataConvertedValues_TestData2(6,:)))/DataSampleRate,TheDataConvertedValues_TestData2(6,:));
%         hold off
%     end    
%     grid on
% end

figure
subplot(3,2,1)
plot((1:numel(TheDataConvertedValues_TestData1(1,:)))/DataSampleRate,100*TheDataConvertedValues_TestData1(1,:));
title("Module 1 Id ")
xlabel('Time (sec)','FontSize',16,'FontWeight','bold');
ylabel('Current (A)','FontSize',16,'FontWeight','bold');
set(gca,'FontSize',FontSize,'FontWeight','bold')

subplot(3,2,2)
plot((1:numel(TheDataConvertedValues_TestData1(2,:)))/DataSampleRate,TheDataConvertedValues_TestData1(2,:));
title("Module 1 Iq ")
xlabel('Time (sec)','FontSize',16,'FontWeight','bold');
ylabel('Current (A)','FontSize',16,'FontWeight','bold');
set(gca,'FontSize',FontSize,'FontWeight','bold')

subplot(3,2,3)
plot((1:numel(TheDataConvertedValues_TestData1(3,:)))/DataSampleRate,TheDataConvertedValues_TestData1(3,:));
title("Module 2 Id ")
xlabel('Time (sec)','FontSize',16,'FontWeight','bold');
ylabel('Current (A)','FontSize',16,'FontWeight','bold');
set(gca,'FontSize',FontSize,'FontWeight','bold')

subplot(3,2,4)
plot((1:numel(TheDataConvertedValues_TestData1(4,:)))/DataSampleRate,TheDataConvertedValues_TestData1(4,:));
title("Module 2 Iq ")
xlabel('Time (sec)','FontSize',16,'FontWeight','bold');
ylabel('Current (A)','FontSize',16,'FontWeight','bold');
set(gca,'FontSize',FontSize,'FontWeight','bold')

subplot(3,2,5)
plot((1:numel(TheDataConvertedValues_TestData1(5,:)))/DataSampleRate,TheDataConvertedValues_TestData1(5,:));
hold on
plot((1:numel(TheDataConvertedValues_TestData1(6,:)))/DataSampleRate,TheDataConvertedValues_TestData1(6,:));
title("Shaft Speed Measured ")
xlabel('Time (sec)','FontSize',16,'FontWeight','bold');
ylabel('Speed (RPM)','FontSize',16,'FontWeight','bold');
set(gca,'FontSize',FontSize,'FontWeight','bold')

subplot(3,2,6)
plot((1:numel(TheDataConvertedValues_TestData1(6,:)))/DataSampleRate,TheDataConvertedValues_TestData1(6,:));
title("Shaft Speed Reference ")
xlabel('Time (sec)','FontSize',16,'FontWeight','bold');
ylabel('Speed (RPM)','FontSize',16,'FontWeight','bold');
set(gca,'FontSize',FontSize,'FontWeight','bold')



figure
subplot(3,2,1)
plot((1:numel(TheDataConvertedValues_TestData2(1,:)))/DataSampleRate,100*TheDataConvertedValues_TestData2(1,:));
title("Module 1 Id ")
xlabel('Time (sec)','FontSize',16,'FontWeight','bold');
ylabel('Current (A)','FontSize',16,'FontWeight','bold');
set(gca,'FontSize',FontSize,'FontWeight','bold')

subplot(3,2,2)
plot((1:numel(TheDataConvertedValues_TestData2(2,:)))/DataSampleRate,TheDataConvertedValues_TestData2(2,:));
title("Module 1 Iq ")
xlabel('Time (sec)','FontSize',16,'FontWeight','bold');
ylabel('Current (A)','FontSize',16,'FontWeight','bold');
set(gca,'FontSize',FontSize,'FontWeight','bold')

subplot(3,2,3)
plot((1:numel(TheDataConvertedValues_TestData2(3,:)))/DataSampleRate,TheDataConvertedValues_TestData2(3,:));
title("Module 2 Id ")
xlabel('Time (sec)','FontSize',16,'FontWeight','bold');
ylabel('Current (A)','FontSize',16,'FontWeight','bold');
set(gca,'FontSize',FontSize,'FontWeight','bold')

subplot(3,2,4)
plot((1:numel(TheDataConvertedValues_TestData2(4,:)))/DataSampleRate,TheDataConvertedValues_TestData2(4,:));
title("Module 2 Iq ")
xlabel('Time (sec)','FontSize',16,'FontWeight','bold');
ylabel('Current (A)','FontSize',16,'FontWeight','bold');
set(gca,'FontSize',FontSize,'FontWeight','bold')

subplot(3,2,5)
plot((1:numel(TheDataConvertedValues_TestData2(5,:)))/DataSampleRate,TheDataConvertedValues_TestData2(5,:));
hold on
plot((1:numel(TheDataConvertedValues_TestData2(6,:)))/DataSampleRate,TheDataConvertedValues_TestData2(6,:));
title("Shaft Speed Measured ")
xlabel('Time (sec)','FontSize',16,'FontWeight','bold');
ylabel('Speed (RPM)','FontSize',16,'FontWeight','bold');
set(gca,'FontSize',FontSize,'FontWeight','bold')

subplot(3,2,6)
plot((1:numel(TheDataConvertedValues_TestData2(6,:)))/DataSampleRate,TheDataConvertedValues_TestData2(6,:));
title("Shaft Speed Reference ")
xlabel('Time (sec)','FontSize',16,'FontWeight','bold');
ylabel('Speed (RPM)','FontSize',16,'FontWeight','bold');
set(gca,'FontSize',FontSize,'FontWeight','bold')


% figure
% for i=1:6
%     subplot(3,2,i)    
%     for j = 1:numel(TheDataConvertedValues_TestData2)
%         
%     end
% %     plot((1:numel(TheDataConvertedValues_TestData2(i,:)))/DataSampleRate,TheDataConvertedValues_TestData2(i,:));
% %     grid on
% end
%%
close all 
indexcounter = 1;
for j = 1:numel(TheDataConvertedValues_TestData1(1,:))
       if(TheDataConvertedValues_TestData1(6,j)==35)
           TestData1_35rpm(:,indexcounter) = TheDataConvertedValues_TestData1(:,j);
           indexcounter = indexcounter + 1;
       end     
       if(indexcounter == 6001)
          break; 
       end
end

indexcounter = 1;
for j = 1:numel(TheDataConvertedValues_TestData1(1,:))
       if(TheDataConvertedValues_TestData1(6,j)==80)
           TestData1_80rpm(:,indexcounter) = TheDataConvertedValues_TestData1(:,j);
           indexcounter = indexcounter + 1;
       end     
       if(indexcounter == 6001)
           break;
       end
end

indexcounter = 1;
for j = 1:numel(TheDataConvertedValues_TestData1(1,:))
       if(TheDataConvertedValues_TestData1(6,j)==-35)
           TestData1_35rpm_minus(:,indexcounter) = TheDataConvertedValues_TestData1(:,j);
           indexcounter = indexcounter + 1;
       end     
       if(indexcounter == 6001)
          break; 
       end       
end

indexcounter = 1;
for j = 1:numel(TheDataConvertedValues_TestData1(1,:))
       if(TheDataConvertedValues_TestData1(6,j)==-80)
           TestData1_80rpm_minus(:,indexcounter) = TheDataConvertedValues_TestData1(:,j);
           indexcounter = indexcounter + 1;
       end     
       if(indexcounter == 6001)
          break; 
       end       
end

indexcounter = 1;
for j = 1:numel(TheDataConvertedValues_TestData2(1,:))
       if(TheDataConvertedValues_TestData2(6,j)==35)
           TestData2_35rpm(:,indexcounter) = TheDataConvertedValues_TestData2(:,j);
           indexcounter = indexcounter + 1;
       end     
       if(indexcounter == 6001)
          break; 
       end       
end

indexcounter = 1;
for j = 1:numel(TheDataConvertedValues_TestData2(1,:))
       if(TheDataConvertedValues_TestData2(6,j)==80)
           TestData2_80rpm(:,indexcounter) = TheDataConvertedValues_TestData2(:,j);
           indexcounter = indexcounter + 1;
       end     
       if(indexcounter == 6001)
          break; 
       end       
end

indexcounter = 1;
for j = 1:numel(TheDataConvertedValues_TestData2(1,:))
       if(TheDataConvertedValues_TestData2(6,j)==-35)
           TestData2_35rpm_minus(:,indexcounter) = TheDataConvertedValues_TestData2(:,j);
           indexcounter = indexcounter + 1;
       end     
       if(indexcounter == 6001)
          break; 
       end       
end

indexcounter = 1;
for j = 1:numel(TheDataConvertedValues_TestData2(1,:))
       if(TheDataConvertedValues_TestData2(6,j)==-80)
           TestData2_80rpm_minus(:,indexcounter) = TheDataConvertedValues_TestData2(:,j);
           indexcounter = indexcounter + 1;
       end     
       if(indexcounter == 6001)
          break; 
       end       
end

figure
for i=1:6
    subplot(3,2,i)
    plot((1:numel(TestData1_35rpm(i,:)))/DataSampleRate,TestData1_35rpm(i,:));
    if(i==5)
        hold on
        plot((1:numel(TestData1_35rpm(6,:)))/DataSampleRate,TestData1_35rpm(6,:));
        hold off
    end
    grid on
end

figure
for i=1:6
    subplot(3,2,i)
    plot((1:numel(TestData1_80rpm(i,:)))/DataSampleRate,TestData1_80rpm(i,:));
    if(i==5)
        hold on
        plot((1:numel(TestData1_80rpm(6,:)))/DataSampleRate,TestData1_80rpm(6,:));
        hold off
    end
    grid on
end

figure
for i=1:6
    subplot(3,2,i)
    plot((1:numel(TestData1_35rpm_minus(i,:)))/DataSampleRate,TestData1_35rpm_minus(i,:));
    if(i==5)
        hold on
        plot((1:numel(TestData1_35rpm_minus(6,:)))/DataSampleRate,TestData1_35rpm_minus(6,:));
        hold off
    end
    grid on
end

figure
for i=1:6
    subplot(3,2,i)
    plot((1:numel(TestData1_80rpm_minus(i,:)))/DataSampleRate,TestData1_80rpm_minus(i,:));
    if(i==5)
        hold on
        plot((1:numel(TestData1_80rpm_minus(6,:)))/DataSampleRate,TestData1_80rpm_minus(6,:));
        hold off
    end
    grid on
end


figure
for i=1:6
    subplot(3,2,i)
    plot((1:numel(TestData2_35rpm(i,:)))/DataSampleRate,TestData2_35rpm(i,:));
    if(i==5)
        hold on
        plot((1:numel(TestData2_35rpm(6,:)))/DataSampleRate,TestData2_35rpm(6,:));
        hold off
    end
    grid on
end

figure
for i=1:6
    subplot(3,2,i)
    plot((1:numel(TestData2_80rpm(i,:)))/DataSampleRate,TestData2_80rpm(i,:));
    if(i==5)
        hold on
        plot((1:numel(TestData2_80rpm(6,:)))/DataSampleRate,TestData2_80rpm(6,:));
        hold off
    end
    grid on
end

figure
for i=1:6
    subplot(3,2,i)
    plot((1:numel(TestData2_35rpm_minus(i,:)))/DataSampleRate,TestData2_35rpm_minus(i,:));
    if(i==5)
        hold on
        plot((1:numel(TestData2_35rpm_minus(6,:)))/DataSampleRate,TestData2_35rpm_minus(6,:));
        hold off
    end
    grid on
end

figure
for i=1:6
    subplot(3,2,i)
    plot((1:numel(TestData2_80rpm_minus(i,:)))/DataSampleRate,TestData2_80rpm_minus(i,:));
    if(i==5)
        hold on
        plot((1:numel(TestData2_80rpm_minus(6,:)))/DataSampleRate,TestData2_80rpm_minus(6,:));
        hold off
    end
    grid on
end
%%
close all
figure
for i=1:6
    subplot(3,2,i)
    plot((1:numel(TestData1_35rpm(i,:)))/DataSampleRate,TestData1_35rpm(i,:),'linewidth',1.5);
    hold all
    plot((1:numel(TestData2_35rpm(i,:)))/DataSampleRate,TestData2_35rpm(i,:),'linewidth',1.5);    
    hold off
    if(i==5)
        hold all
        plot((1:numel(TestData1_35rpm(6,:)))/DataSampleRate,TestData1_35rpm(6,:),'linewidth',1.5);
        plot((1:numel(TestData2_35rpm(6,:)))/DataSampleRate,TestData2_35rpm(6,:),'linewidth',1.5);
        hold off
    end
    grid on
    if(i==1)
        title("Module 1 Id ")
        xlabel('Time (sec)','FontSize',16,'FontWeight','bold');
        ylabel('Current (A)','FontSize',16,'FontWeight','bold');
        ylim([-0.3 0.3])        
        Text = sprintf('Yes Load Id Mean: %f ',mean(TestData1_35rpm(i,:)));
        text(0,double(mean(TestData1_35rpm(i,:)))+0.1,Text, 'FontSize', 16,'FontWeight','bold')
        Text = sprintf('No Load Id Mean: %f ',mean(TestData2_35rpm(i,:)));        
        text(0,double(mean(TestData2_35rpm(i,:)))-0.1,Text, 'FontSize', 16,'FontWeight','bold')
    end
    if(i==2)
        title("Module 1 Iq ")
        xlabel('Time (sec)','FontSize',16,'FontWeight','bold');
        ylabel('Current (A)','FontSize',16,'FontWeight','bold');
        Text = sprintf('Yes Load Iq Mean: %f ',mean(TestData1_35rpm(i,:)));
        text(0,double(mean(TestData1_35rpm(i,:)))+0.2,Text, 'FontSize', 16,'FontWeight','bold')
        Text = sprintf('No Load Iq Mean: %f ',mean(TestData2_35rpm(i,:)));        
        text(0,double(mean(TestData2_35rpm(i,:)))-0.2,Text, 'FontSize', 16,'FontWeight','bold')        
    end        
    if(i==3)
        title("Module 2 Id ")
        xlabel('Time (sec)','FontSize',16,'FontWeight','bold');
        ylabel('Current (A)','FontSize',16,'FontWeight','bold');
        ylim([-0.3 0.3])
        Text = sprintf('Yes Load Id Mean: %f ',mean(TestData1_35rpm(i,:)));
        text(0,double(mean(TestData1_35rpm(i,:)))+0.1,Text, 'FontSize', 16,'FontWeight','bold')
        Text = sprintf('No Load Id Mean: %f ',mean(TestData2_35rpm(i,:)));        
        text(0,double(mean(TestData2_35rpm(i,:)))-0.1,Text, 'FontSize', 16,'FontWeight','bold')        
    end    
    if(i==4)
        title("Module 2 Iq ")
        xlabel('Time (sec)','FontSize',16,'FontWeight','bold');
        ylabel('Current (A)','FontSize',16,'FontWeight','bold');
        Text = sprintf('Yes Load Iq Mean: %f ',mean(TestData1_35rpm(i,:)));
        text(0,double(mean(TestData1_35rpm(i,:)))+0.2,Text, 'FontSize', 16,'FontWeight','bold')
        Text = sprintf('No Load Iq Mean: %f ',mean(TestData2_35rpm(i,:)));        
        text(0,double(mean(TestData2_35rpm(i,:)))-0.2,Text, 'FontSize', 16,'FontWeight','bold')           
    end    
    if(i==5)
        title("Shaft Speed Measured ")
        xlabel('Time (sec)','FontSize',16,'FontWeight','bold');
        ylabel('Speed (RPM)','FontSize',16,'FontWeight','bold');
    end    
    if(i==6)
        title("Shaft Speed Reference ")
        xlabel('Time (sec)','FontSize',16,'FontWeight','bold');
        ylabel('Speed (RPM)','FontSize',16,'FontWeight','bold');
    end        
        legend('Yes load', 'No load')
        set(gca,'FontSize',16,'FontWeight','bold')
end

figure
for i=1:6
    subplot(3,2,i)
    plot((1:numel(TestData1_80rpm(i,:)))/DataSampleRate,TestData1_80rpm(i,:),'linewidth',1.5);
    hold all
    plot((1:numel(TestData2_80rpm(i,:)))/DataSampleRate,TestData2_80rpm(i,:),'linewidth',1.5);    
    hold off
    if(i==5)
        hold all
        plot((1:numel(TestData1_80rpm(6,:)))/DataSampleRate,TestData1_80rpm(6,:),'linewidth',1.5);
        plot((1:numel(TestData2_80rpm(6,:)))/DataSampleRate,TestData2_80rpm(6,:),'linewidth',1.5);
        hold off
    end
    grid on
    if(i==1)
        title("Module 1 Id ")
        xlabel('Time (sec)','FontSize',16,'FontWeight','bold');
        ylabel('Current (A)','FontSize',16,'FontWeight','bold');
        ylim([-0.3 0.3])        
        Text = sprintf('Yes Load Id Mean: %f ',mean(TestData1_80rpm(i,:)));
        text(0,double(mean(TestData1_80rpm(i,:)))+0.1,Text, 'FontSize', 16,'FontWeight','bold')
        Text = sprintf('No Load Id Mean: %f ',mean(TestData2_80rpm(i,:)));        
        text(0,double(mean(TestData2_80rpm(i,:)))-0.1,Text, 'FontSize', 16,'FontWeight','bold')
    end
    if(i==2)
        title("Module 1 Iq ")
        xlabel('Time (sec)','FontSize',16,'FontWeight','bold');
        ylabel('Current (A)','FontSize',16,'FontWeight','bold');
        Text = sprintf('Yes Load Iq Mean: %f ',mean(TestData1_80rpm(i,:)));
        text(0,double(mean(TestData1_80rpm(i,:)))+0.2,Text, 'FontSize', 16,'FontWeight','bold')
        Text = sprintf('No Load Iq Mean: %f ',mean(TestData2_80rpm(i,:)));        
        text(0,double(mean(TestData2_80rpm(i,:)))-0.2,Text, 'FontSize', 16,'FontWeight','bold')        
    end        
    if(i==3)
        title("Module 2 Id ")
        xlabel('Time (sec)','FontSize',16,'FontWeight','bold');
        ylabel('Current (A)','FontSize',16,'FontWeight','bold');
        ylim([-0.3 0.3])
        Text = sprintf('Yes Load Id Mean: %f ',mean(TestData1_80rpm(i,:)));
        text(0,double(mean(TestData1_80rpm(i,:)))+0.1,Text, 'FontSize', 16,'FontWeight','bold')
        Text = sprintf('No Load Id Mean: %f ',mean(TestData2_80rpm(i,:)));        
        text(0,double(mean(TestData2_80rpm(i,:)))-0.1,Text, 'FontSize', 16,'FontWeight','bold')        
    end    
    if(i==4)
        title("Module 2 Iq ")
        xlabel('Time (sec)','FontSize',16,'FontWeight','bold');
        ylabel('Current (A)','FontSize',16,'FontWeight','bold');
        Text = sprintf('Yes Load Iq Mean: %f ',mean(TestData1_80rpm(i,:)));
        text(0,double(mean(TestData1_80rpm(i,:)))+0.2,Text, 'FontSize', 16,'FontWeight','bold')
        Text = sprintf('No Load Iq Mean: %f ',mean(TestData2_80rpm(i,:)));        
        text(0,double(mean(TestData2_80rpm(i,:)))-0.2,Text, 'FontSize', 16,'FontWeight','bold')           
    end    
    if(i==5)
        title("Shaft Speed Measured ")
        xlabel('Time (sec)','FontSize',16,'FontWeight','bold');
        ylabel('Speed (RPM)','FontSize',16,'FontWeight','bold');
    end    
    if(i==6)
        title("Shaft Speed Reference ")
        xlabel('Time (sec)','FontSize',16,'FontWeight','bold');
        ylabel('Speed (RPM)','FontSize',16,'FontWeight','bold');
    end        
        legend('Yes load', 'No load')
        set(gca,'FontSize',16,'FontWeight','bold')
end

figure
for i=1:6
    subplot(3,2,i)
    plot((1:numel(TestData1_80rpm_minus(i,:)))/DataSampleRate,TestData1_80rpm_minus(i,:),'linewidth',1.5);
    hold all
    plot((1:numel(TestData2_80rpm_minus(i,:)))/DataSampleRate,TestData2_80rpm_minus(i,:),'linewidth',1.5);    
    hold off
    if(i==5)
        hold all
        plot((1:numel(TestData1_80rpm_minus(6,:)))/DataSampleRate,TestData1_80rpm_minus(6,:),'linewidth',1.5);
        plot((1:numel(TestData2_80rpm_minus(6,:)))/DataSampleRate,TestData2_80rpm_minus(6,:),'linewidth',1.5);
        hold off
    end
    grid on
    if(i==1)
        title("Module 1 Id ")
        xlabel('Time (sec)','FontSize',16,'FontWeight','bold');
        ylabel('Current (A)','FontSize',16,'FontWeight','bold');
        ylim([-0.3 0.3])        
        Text = sprintf('Yes Load Id Mean: %f ',mean(TestData1_80rpm_minus(i,:)));
        text(0,double(mean(TestData1_80rpm_minus(i,:)))+0.1,Text, 'FontSize', 16,'FontWeight','bold')
        Text = sprintf('No Load Id Mean: %f ',mean(TestData2_80rpm_minus(i,:)));        
        text(0,double(mean(TestData2_80rpm_minus(i,:)))-0.1,Text, 'FontSize', 16,'FontWeight','bold')
    end
    if(i==2)
        title("Module 1 Iq ")
        xlabel('Time (sec)','FontSize',16,'FontWeight','bold');
        ylabel('Current (A)','FontSize',16,'FontWeight','bold');
        Text = sprintf('Yes Load Iq Mean: %f ',mean(TestData1_80rpm_minus(i,:)));
        text(0,double(mean(TestData1_80rpm_minus(i,:)))+0.2,Text, 'FontSize', 16,'FontWeight','bold')
        Text = sprintf('No Load Iq Mean: %f ',mean(TestData2_80rpm_minus(i,:)));        
        text(0,double(mean(TestData2_80rpm_minus(i,:)))-0.2,Text, 'FontSize', 16,'FontWeight','bold')        
    end        
    if(i==3)
        title("Module 2 Id ")
        xlabel('Time (sec)','FontSize',16,'FontWeight','bold');
        ylabel('Current (A)','FontSize',16,'FontWeight','bold');
        ylim([-0.3 0.3])
        Text = sprintf('Yes Load Id Mean: %f ',mean(TestData1_80rpm_minus(i,:)));
        text(0,double(mean(TestData1_80rpm_minus(i,:)))+0.1,Text, 'FontSize', 16,'FontWeight','bold')
        Text = sprintf('No Load Id Mean: %f ',mean(TestData2_80rpm_minus(i,:)));        
        text(0,double(mean(TestData2_80rpm_minus(i,:)))-0.1,Text, 'FontSize', 16,'FontWeight','bold')        
    end    
    if(i==4)
        title("Module 2 Iq ")
        xlabel('Time (sec)','FontSize',16,'FontWeight','bold');
        ylabel('Current (A)','FontSize',16,'FontWeight','bold');
        Text = sprintf('Yes Load Iq Mean: %f ',mean(TestData1_80rpm_minus(i,:)));
        text(0,double(mean(TestData1_80rpm_minus(i,:)))+0.2,Text, 'FontSize', 16,'FontWeight','bold')
        Text = sprintf('No Load Iq Mean: %f ',mean(TestData2_80rpm_minus(i,:)));        
        text(0,double(mean(TestData2_80rpm_minus(i,:)))-0.2,Text, 'FontSize', 16,'FontWeight','bold')           
    end    
    if(i==5)
        title("Shaft Speed Measured ")
        xlabel('Time (sec)','FontSize',16,'FontWeight','bold');
        ylabel('Speed (RPM)','FontSize',16,'FontWeight','bold');
    end    
    if(i==6)
        title("Shaft Speed Reference ")
        xlabel('Time (sec)','FontSize',16,'FontWeight','bold');
        ylabel('Speed (RPM)','FontSize',16,'FontWeight','bold');
    end        
        legend('Yes load', 'No load')
        set(gca,'FontSize',16,'FontWeight','bold')
end

figure
for i=1:6
    subplot(3,2,i)
    plot((1:numel(TestData1_35rpm_minus(i,:)))/DataSampleRate,TestData1_35rpm_minus(i,:),'linewidth',1.5);
    hold all
    plot((1:numel(TestData2_35rpm_minus(i,:)))/DataSampleRate,TestData2_35rpm_minus(i,:),'linewidth',1.5);    
    hold off
    if(i==5)
        hold all
        plot((1:numel(TestData1_35rpm_minus(6,:)))/DataSampleRate,TestData1_35rpm_minus(6,:),'linewidth',1.5);
        plot((1:numel(TestData2_35rpm_minus(6,:)))/DataSampleRate,TestData2_35rpm_minus(6,:),'linewidth',1.5);
        hold off
    end
    grid on
    if(i==1)
        title("Module 1 Id ")
        xlabel('Time (sec)','FontSize',16,'FontWeight','bold');
        ylabel('Current (A)','FontSize',16,'FontWeight','bold');
        ylim([-0.3 0.3])        
        Text = sprintf('Yes Load Id Mean: %f ',mean(TestData1_35rpm_minus(i,:)));
        text(0,double(mean(TestData1_35rpm_minus(i,:)))+0.1,Text, 'FontSize', 16,'FontWeight','bold')
        Text = sprintf('No Load Id Mean: %f ',mean(TestData2_35rpm_minus(i,:)));        
        text(0,double(mean(TestData2_35rpm_minus(i,:)))-0.1,Text, 'FontSize', 16,'FontWeight','bold')
    end
    if(i==2)
        title("Module 1 Iq ")
        xlabel('Time (sec)','FontSize',16,'FontWeight','bold');
        ylabel('Current (A)','FontSize',16,'FontWeight','bold');
        Text = sprintf('Yes Load Iq Mean: %f ',mean(TestData1_35rpm_minus(i,:)));
        text(0,double(mean(TestData1_35rpm_minus(i,:)))-0.2,Text, 'FontSize', 16,'FontWeight','bold')
        Text = sprintf('No Load Iq Mean: %f ',mean(TestData2_35rpm_minus(i,:)));        
        text(0,double(mean(TestData2_35rpm_minus(i,:)))+0.2,Text, 'FontSize', 16,'FontWeight','bold')        
    end        
    if(i==3)
        title("Module 2 Id ")
        xlabel('Time (sec)','FontSize',16,'FontWeight','bold');
        ylabel('Current (A)','FontSize',16,'FontWeight','bold');
        ylim([-0.3 0.3])
        Text = sprintf('Yes Load Id Mean: %f ',mean(TestData1_35rpm_minus(i,:)));
        text(0,double(mean(TestData1_35rpm_minus(i,:)))+0.1,Text, 'FontSize', 16,'FontWeight','bold')
        Text = sprintf('No Load Id Mean: %f ',mean(TestData2_35rpm_minus(i,:)));        
        text(0,double(mean(TestData2_35rpm_minus(i,:)))-0.1,Text, 'FontSize', 16,'FontWeight','bold')        
    end    
    if(i==4)
        title("Module 2 Iq ")
        xlabel('Time (sec)','FontSize',16,'FontWeight','bold');
        ylabel('Current (A)','FontSize',16,'FontWeight','bold');
        Text = sprintf('Yes Load Iq Mean: %f ',mean(TestData1_35rpm_minus(i,:)));
        text(0,double(mean(TestData1_35rpm_minus(i,:)))-0.2,Text, 'FontSize', 16,'FontWeight','bold')
        Text = sprintf('No Load Iq Mean: %f ',mean(TestData2_35rpm_minus(i,:)));        
        text(0,double(mean(TestData2_35rpm_minus(i,:)))+0.2,Text, 'FontSize', 16,'FontWeight','bold')           
    end    
    if(i==5)
        title("Shaft Speed Measured ")
        xlabel('Time (sec)','FontSize',16,'FontWeight','bold');
        ylabel('Speed (RPM)','FontSize',16,'FontWeight','bold');
    end    
    if(i==6)
        title("Shaft Speed Reference ")
        xlabel('Time (sec)','FontSize',16,'FontWeight','bold');
        ylabel('Speed (RPM)','FontSize',16,'FontWeight','bold');
    end        
        legend('Yes load', 'No load')
        set(gca,'FontSize',16,'FontWeight','bold')
end




