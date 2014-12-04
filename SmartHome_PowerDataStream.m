% Bass Connections in Energy Team

function SmartHome_PowerDataStream
% Select a data set from the pop-up menu, then
% click the 'Start' toggle button. Clicking the button
% plots the selected data in the axes.

%  Create and then hide the GUI as it is being constructed.
f = figure('Visible','off','Position',[720,1000,900,570]);
current_data = [];

%  Construct the components.
hstart = uicontrol('Style','togglebutton','String','Start',...
    'Position',[315,220,70,25],...
    'Callback',{@start_Callback});

htext = uicontrol('Style','text','String','Select dataset from drop-down menu, then click START',...
    'Position',[325,90,60,15]);

hpopup = uicontrol('Style','popupmenu',...
    'String',{'Total Power Phase A', 'Total Power Phase B','Solar Panel 1','Solar Panel 2',...
    'Refrigerator', 'Microwave', 'Dishwasher', 'Oven', 'Cooktop',...
    'Kitchen Unit 1', 'Kitchen Unit 2','Kitchen Unit3', ...
    'Washing Machine', 'Dryer', 'Hot box', ...
    'Air Handler Unit 1','Air Handler Unit 2', 'Compressor Unit 1','Compressor Unit 2',...
    'Air Recirculation Unit','Irrigation'},...
    'Position',[300,50,100,25],...
    'Callback',{@popup_menu_Callback});
ha = axes('Units','Pixels','Position',[50,60,200,185]);
align([hstart,htext,hpopup],'Center','None');

% Initialize the GUI.
% Change units to normalized so components resize
% automatically.
set([f,ha,hstart,htext,hpopup],...
    'Units','normalized');

% Assign the GUI a name to appear in the window title.
set(f,'Name','Simple GUI')
% Move the GUI to the center of the screen.
movegui(f,'center')
% Make the GUI visible.
set(f,'Visible','on');


%  Pop-up menu callback. Read the pop-up menu Value property
%  to determine which item is currently displayed and make it
%  the current data.
    function popup_menu_Callback(source,eventdata)
        % Determine the selected data set.
        str = get(source, 'String');
        val = get(source,'Value');
        % Set current data to the selected data set.
        switch str{val};
            case 'Total Power Phase A'
                machineNum = 2;
            case 'Total Power Phase B'
                machineNum = 3;
            case 'Solar Panel 1'
                machineNum = 4;
            case 'Solar Panel 2'
                machineNum = 5;
            case 'Refrigerator' % User selects Peaks.
                machineNum = 12;
            case 'Microwave' % User selects Membrane.
                machineNum = 13;
            case 'Dishwasher' % User selects Sinc.
                machineNum = 14;
            case 'Oven'
                machineNum = 15;
            case 'Cooktop'
                machineNum = 16;
            case 'Kitchen Unit 1'
                machineNum = 17;
            case 'Kitchen Unit 2'
                machineNum = 18;
            case 'Kitchen Unit 3'
                machineNum = 19;
            case 'Washing Machine'
                machineNum = 20;
            case 'Dryer'
                machineNum = 21;
            case 'Hotbox'
                machineNum = 22;
            case 'Air Handler 1'
                machineNum = 23;
            case 'Air Handler 2'
                machineNum = 24;
            case 'Compressor Unit 1'
                machineNum = 25;
            case 'Compressor Unit 2'
                machineNum = 26;
            case 'Air Recirculation Unit'
                machineNum = 27;
            case 'Irrigation'
                machineNum = 29;
        end
        current_data = generateData(:,machineNum);
    end

% Toggle button callbacks. Each callback plots current_data in the specified plot type.

hplot(1) = plot(current_data);

    function start_Callback(hObject,eventdata,handles)
        if get(hObject,'Value')
            set(hObject,'String','Streaming');
        else
            set(hObject,'String','Start');
        end
        
        while get(hObject,'Value')
            current_data=circshift(current_data,[1,0]);
            current_data(1)= NewPowerReading();   %% add new data
            set(hplot(1),'YData',current_data);
            drawnow
        end
    end

end
