function simple_gui_test
%% Initialize Data:
clear; clc;
load('phaseData.mat', 'phaseData' );
% load('fridgedata.mat', 'fridgeData');
load('timeString.mat', 'timeString');
load('timevec.mat', 'timevec')
load('solarData.mat', 'solarData');
load('pieColorMap.mat','pieColorMap');

%% Global Variables
option = 'Total Power';
counter = 0;

%% Modifying Solar Data and Phase A data:
% Column 1: Phase A Power Data (modified by taking out solar data)
% Column 2: Phase B Power Data
% Column 3: Solar Power Data
% Column 4: Refrigerator Power Data
% Column 5: Total Power Data

solarData = -1*(solarData(:,1) + solarData(:,2));
phaseData(:,1) = phaseData(:,1) + solarData;
totalData = phaseData(:,1) + phaseData(:,2);
sampleDataSet = [totalData phaseData solarData];
sampleTime = timevec;
%% GUI Code
% Select a data set from the pop-up menu, then
% click the toggle button. Clicking the button
% plots the selected data in the axes.

%  Create and then hide the GUI as it is being constructed.
f = figure('Visible','off','Position',[270,1000,900,570]);
current_data = [sampleDataSet(:,1)];
current_time = [sampleTime(:,1)];

%  Construct the components.
hstart = uicontrol('Style','togglebutton','String','Start',...
    'Position',[670,440,125,40],...
    'Callback',{@start_Callback},'FontSize',16);

htext = uicontrol('Style','text','String','Select Data Source',...
    'Position',[600,400,120,15],'FontSize',12,'BackgroundColor','w');

hpopup = uicontrol('Style','popupmenu',...
    'String',{'Total Power','Phase A Power', 'Phase B Power', 'Solar Power',...
    'Refrigerator Power'},...
    'Position',[600,340,135,50],...
    'Callback',{@popup_menu_Callback},...
    'FontSize',12);
ha = axes('Units','Pixels','Position',[100,120,400,370],'Visible','off');
hb = axes('Units', 'Pixels', 'Position', [600, 120, 200, 200],'Visible','off');
align([hstart,htext,hpopup],'Center','None');

% Initialize the GUI.
% Change units to normalized so components resize automatically.
set([f,ha,hb,hstart,htext,hpopup],...
    'Units','normalized');
% Assign the GUI a name to appear in the window title.
set(f,'Name','Test GUI')
% Move the GUI to the center of the screen.
movegui(f,'center')
% Make the GUI visible.
set(f,'Visible','on','Color','w');


    function popup_menu_Callback(source,eventdata)
        % Determine the selected data set.
        str = get(source, 'String');
        val = get(source,'Value');
        % Set current data to the selected data set.
        switch str{val};
            case 'Total Power'
                current_data = sampleDataSet(:,1);
                option = 'Total Power';
                counter = 20;
            case 'Phase A Power'
                current_data = sampleDataSet(:,2);
                option = 'Phase A Power';
                counter = 20;
            case 'Phase B Power'
                current_data = sampleDataSet(:,3);
                option = 'Phase B Power';
                counter = 20;
            case 'Solar Power'
                current_data = sampleDataSet(:,4);
                option = 'Solar Power';
                counter = 20;
            case 'Refrigerator Power'
                current_data = sampleDataSet(:,5);
                option = 'Refrigerator Power';
                counter = 20;
        end
    end

% Push button callbacks. Each callback plots current_data in
% the specified plot type.

axes(hb);
pie(0);

    function start_Callback(hObject,eventdata,handles)
        if get(hObject,'Value')
            set(hObject,'String','Streaming');
        else set(hObject,'String','Start');
        end
        
        %axes(hb);
        %pie(1:10);
        
        axes(ha);
        latest_data = flipud(current_data(1:200));
        latest_time = current_time(1:200);
        mplot(1) = plot(linspace(numel(latest_data),1,numel(latest_data)), latest_data);
        title('Smart Home Power Data','FontSize',16,'FontWeight','bold');
        xlabel(datestr(latest_time(200,1)/86400+719529,1),'FontSize',14);
        ylabel('Power (W)','FontSize',14);
        set(gca,'FontSize',12,'XTick',[0,200],...
            'XTickLabel',{datestr(latest_time(1,1)/86400+719529,13),...
            datestr(latest_time(200,1)/86400+719529,13)});
        
        
        while(get(hObject, 'Value'))
            axes(ha);
            current_data = circshift(current_data, [-1,0]);
            current_time = circshift(current_time, [-1,0]);
            sampleDataSet(:,1) = circshift(sampleDataSet(:,1), [-1,0]);
            sampleDataSet(:,2) = circshift(sampleDataSet(:,2), [-1,0]);
            sampleDataSet(:,3) = circshift(sampleDataSet(:,3), [-1,0]);
            sampleDataSet(:,4) = circshift(sampleDataSet(:,4), [-1,0]);
            sampleDataSet(:,5) = circshift(sampleDataSet(:,5), [-1,0]);
            sampleTime(:,1) = circshift(sampleTime(:,1), [-1,0]);
            latest_data = flipud(current_data(1:200));
            latest_time = current_time(1:200);
            %latest_data = circshift(lastest_data, [1, 0]);
            %latest_data(1) = current_data(numel(current_data));
            set(mplot(1), 'YData', latest_data);
            axis([0, 200, 0 , 8000]);
            xlabel(datestr(latest_time(200,1)/86400+719529,1),'FontSize',14);
            ylabel('Power (W)','FontSize',14);
            set(gca,'FontSize',12,'XTick',[0,200],...
                'XTickLabel',{datestr(latest_time(1,1)/86400+719529,13),...
                datestr(latest_time(200,1)/86400+719529,13)});
            counter = counter + 1;
            if counter == 20
                pause(0.01);
            else
                pause(0.5);
            end
            drawnow;
            
            if counter == 20 | 40
                counter = 0;
                axes(hb);
                
                switch option
                    case 'Total Power'
                        phaseAData = sampleDataSet(:,2);
                        phaseBData = sampleDataSet(:,3);
                        
                        phaseA_average = mean(phaseAData(1:200));
                        phaseB_average = mean(phaseBData(1:200));
                        
                        pie([phaseA_average, phaseB_average]);
                        colormap([1 0.8 0.2; 0.6 1 1]);
                        legend('Phase A','PhaseB','Location','SouthOutside');
                    case 'Phase A Power'
                        phaseAData = sampleDataSet(:,2);
                        phaseBData = sampleDataSet(:,3);
                        
                        phaseA_average = mean(phaseAData(1:200));
                        phaseB_average = mean(phaseBData(1:200));
                        
                        pie([phaseA_average, phaseB_average]);
                        colormap([1 0.8 0.2; 0.6 1 1]);
                        legend('Phase A','PhaseB','Location','SouthOutside');
                    case 'Phase B Power'
                        phaseAData = sampleDataSet(:,2);
                        phaseBData = sampleDataSet(:,3);
                        
                        phaseA_average = mean(phaseAData(1:200));
                        phaseB_average = mean(phaseBData(1:200));
                        
                        pie([phaseA_average, phaseB_average]);
                        colormap([1 0.8 0.2; 0.6 1 1]);
                        legend('Phase A','PhaseB','Location','SouthOutside');
                    case 'Solar Power'
                        solarPowerData = sampleDataSet(:,4);
                        totalPowerData = sampleDataSet(:,1);
                        
                        solarPower_average = mean(solarPowerData(1:200));
                        totalPower_average = mean(totalPowerData(1:200));
                        
                        pie([solarPower_average,...
                            totalPower_average - solarPower_average]);
                        colormap([0.8 1 0.2; 0.8 0.8 1]);
                        legend('Solar Power','Grid Power','Location','SouthOutside');
                    case 'Refrigerator Power'
                        refrigeratorData = sampleDataSet(:,5);
                        totalPowerData = sampleDataSet(:,1);
                        
                        refrigerator_average = mean(refrigeratorData(1:200));
                        totalPower_average = mean(totalPowerData(1:200));
                        
                        pie([refrigerator_average,...
                            totalPower_average - refrigerator_average]);
                        colormap([1 0.4 0.4; 0.2 0.4 1]);
                        legend('Refrigerator','Other Appliances','Location','SouthOutside');
                end
            end
        end
        
    end
end