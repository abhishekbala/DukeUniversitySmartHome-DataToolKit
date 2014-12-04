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
current_data = [myData(:,3)];

%  Construct the components.
hstart = uicontrol('Style','togglebutton','String','Start',...
    'Position',[630,460,140,50],...
    'Callback',{@start_Callback});

htext = uicontrol('Style','text','String','Select Data',...
    'Position',[650,380,120,30]);

hpopup = uicontrol('Style','popupmenu',...
    'String',{'Refrigerator Power', 'Total Power Phase A','Total Power Phase B'},...
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
            case 'Refrigerator Power'
                current_data = myData(:,3);
            case 'Total Power Phase A' % User selects Peaks.
                current_data = myData(:,1);
                
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
        
            axes(hb);
            pie(1:10);
            
            axes(ha);
            latest_data = current_data(1:200);
            mplot(1) = plot(latest_data);
            while(get(hObject, 'Value'))
                current_data = circshift(current_data, [1,0]);
                latest_data = current_data(1:200);
                %latest_data = circshift(lastest_data, [1, 0]);
                %latest_data(1) = current_data(numel(current_data));
                set(mplot(1), 'YData', latest_data);
                axis([0, 200, 0 , 3000]);
                pause(1);
                drawnow;
            end

    end
end