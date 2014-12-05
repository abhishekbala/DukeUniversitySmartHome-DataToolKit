function simple_gui_test
%% Initialize Data:
clear; clc;
load('phaseData.mat', 'r' );
load('fridgedata.mat', 'fridgedata');
myData = [r fridgedata];

%% Main Code
% Select a data set from the pop-up menu, then
% click the toggle button. Clicking the button
% plots the selected data in the axes.

%  Create and then hide the GUI as it is being constructed.
f = figure('Visible','off','Position',[270,1000,900,570]);
current_data = [myData(:,1)];

%  Construct the components.
hstart = uicontrol('Style','togglebutton','String','Start',...
    'Position',[630,460,140,50],...
    'Callback',{@start_Callback});

htext = uicontrol('Style','text','String','Select Data',...
    'Position',[650,380,120,30]);

hpopup = uicontrol('Style','popupmenu',...
    'String',{'Total Power Phase A', 'Refrigerator Power','Total Power Phase B'},...
    'Position',[600,300,200,50],...
    'Callback',{@popup_menu_Callback});
ha = axes('Units','Pixels','Position',[100,120,400,370]);
hb = axes('Units', 'Pixels', 'Position', [600, 100, 200, 185]);
align([hstart,htext,hpopup],'Center','None');

% Initialize the GUI.
% Change units to normalized so components resize automatically.
set([f,ha,hstart,htext,hpopup],...
    'Units','normalized');
% Assign the GUI a name to appear in the window title.
set(f,'Name','Test GUI')
% Move the GUI to the center of the screen.
movegui(f,'center')
% Make the GUI visible.
set(f,'Visible','on');


    function popup_menu_Callback(source,eventdata)
        % Determine the selected data set.
        str = get(source, 'String');
        val = get(source,'Value');
        % Set current data to the selected data set.
        switch str{val};
            case 'Total Power Phase A' % User selects Peaks.
                current_data = myData(:,1);
            case 'Refrigerator Power'
                current_data = myData(:,3);
                
            case 'Total Power Phase B' % User selects Membrane.
                current_data = myData(:,2);
        end
    end

% Push button callbacks. Each callback plots current_data in
% the specified plot type.

axes(hb);
pie(1);
    function start_Callback(hObject,eventdata,handles)
        if get(hObject,'Value')
            set(hObject,'String','Streaming');
        else set(hObject,'String','Start');
        end
        
        %axes(hb);
        %pie(1:10);
        
        axes(ha);
        latest_data = current_data(1:200);
        mplot(1) = plot(linspace(numel(latest_data),1,numel(latest_data)), latest_data);
        
        counter = 0;
        while(get(hObject, 'Value'))
            axes(ha);
            current_data = circshift(current_data, [1,0]);
            myData(:,1) = circshift(myData(:,1), [1,0]);
            myData(:,2) = circshift(myData(:,2), [1,0]);
            myData(:,3) = circshift(myData(:,3), [1,0]);
            latest_data = current_data(1:200);
            %latest_data = circshift(lastest_data, [1, 0]);
            %latest_data(1) = current_data(numel(current_data));
            set(mplot(1), 'YData', latest_data);
            axis([0, 200, 0 , 3000]);
            counter = counter + 1;
            if counter == 20
                pause(0.01);
            else
            pause(0.1);
            end
            drawnow;
            
            if counter == 20
                counter = 0;
                axes(hb);
                a_1 = myData(:,1);
                b_1 = myData(:,2);
                %A_avg_short = a_1(1:200);
                %B_avg_short = b_1(1:200);
                %PhaseA_average = mean(A_avg_short);
                %PhaseB_average = mean(B_avg_short);
                PhaseA_average = mean(a_1(1:200));
                PhaseB_average = mean(b_1(1:200));
                
                pie([PhaseA_average, PhaseB_average]);
                legend('A','B', [525, 60,0.25,0.1]);
            end
        end
        
    end
end